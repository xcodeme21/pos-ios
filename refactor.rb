require 'xcodeproj'
require 'fileutils'

project_path = 'pos ios.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Ensure 'pos ios' group exists, otherwise use root or find it
main_group = project.main_group.find_subpath('pos ios', false)
if main_group.nil?
    puts "Error: main group 'pos ios' not found."
    exit(1)
end

# Define the new structure
structure = {
  'Core' => {
    'Components' => [
      'CustomButton.swift', 'CustomText.swift', 'CustomTextField.swift', 
      'GlassBackground.swift', 'StoreCard.swift', 'ReportFormCard.swift'
    ],
    'Network' => [
      'Config.swift', 'NetworkManager.swift', 'NetworkManagerPDF.swift'
    ],
    'Utils' => [
      'CryptoUtils.swift', 'FirebaseRemoteConfigManager.swift', 
      'String.swift', 'ThemeManager.swift'
    ]
  },
  'Features' => {
    'Authentication' => ['LoginView.swift', 'LoginViewModel.swift'],
    'StoreSelection' => ['StoreSelectionView.swift', 'StoreSelectionViewModel.swift', 'Store.swift'],
    'Dashboard' => ['DashboardView.swift', 'PlaceholderMenuView.swift', 'Sales.swift'],
    'Transaction' => ['TransactionView.swift'],
    'Reports' => ['LaporanView.swift'],
    'Promo' => [
      'CekPromoView.swift', 'CekPromoItemView.swift', 'CekPromoItemViewModel.swift',
      'CekPromoBankIssuerView.swift', 'CekPromoBankIssuerViewModel.swift', 'CekPromoModels.swift'
    ],
    'Profile' => ['ProfilView.swift', 'AkunSayaView.swift']
  },
  'App' => ['ContentView.swift', 'pos_iosApp.swift']
}

# Base physical directory
base_dir = 'pos ios'

# Create groups and move files
structure.each do |top_level, sub_levels|
  # Create top level group if needed
  top_group = main_group[top_level] || main_group.new_group(top_level, top_level)
  top_dir = File.join(base_dir, top_level)
  FileUtils.mkdir_p(top_dir)

  if sub_levels.is_a?(Hash)
    sub_levels.each do |module_name, files|
      mod_group = top_group[module_name] || top_group.new_group(module_name, module_name)
      mod_dir = File.join(top_dir, module_name)
      FileUtils.mkdir_p(mod_dir)

      files.each do |file_name|
        # Find the file in the project
        file_refs = project.files.select { |f| f.name == file_name || (f.path && File.basename(f.path) == file_name) }
        
        if file_refs.empty?
          puts "Warning: Could not find references for #{file_name} in Xcode project."
          next
        end

        file_refs.each do |file_ref|
          old_physical_path = file_ref.real_path.to_s
          new_physical_path = File.join(mod_dir, file_name)

          if File.exist?(old_physical_path) && old_physical_path != new_physical_path
            # Move physical file
            FileUtils.mv(old_physical_path, new_physical_path)
            puts "Moved: #{old_physical_path} -> #{new_physical_path}"
          end

          # Remove old reference and add new one
          file_ref.remove_from_project
          
          # Add to new group
          new_ref = mod_group.new_file(file_name)
          
          # Add to active target (assume we want to add to the main target)
          target = project.targets.find { |t| t.name == 'pos ios' }
          target.source_build_phase.add_file_reference(new_ref) if target
        end
      end
    end
  elsif sub_levels.is_a?(Array)
    # App level files
    sub_levels.each do |file_name|
      file_refs = project.files.select { |f| f.name == file_name || (f.path && File.basename(f.path) == file_name) }
      
      if file_refs.empty?
        puts "Warning: Could not find references for #{file_name} in Xcode project."
        next
      end

      file_refs.each do |file_ref|
        old_physical_path = file_ref.real_path.to_s
        new_physical_path = File.join(top_dir, file_name)

        if File.exist?(old_physical_path) && old_physical_path != new_physical_path
          FileUtils.mv(old_physical_path, new_physical_path)
          puts "Moved: #{old_physical_path} -> #{new_physical_path}"
        end

        file_ref.remove_from_project
        new_ref = top_group.new_file(file_name)
        
        target = project.targets.find { |t| t.name == 'pos ios' }
        target.source_build_phase.add_file_reference(new_ref) if target
      end
    end
  end
end

# Optional: Clean up empty old groups (Views, ViewModels, etc)
['Views', 'ViewModels', 'Models', 'Services', 'Components'].each do |old_folder|
  old_group = main_group[old_folder]
  if old_group && old_group.children.empty?
    old_group.remove_from_project
    puts "Removed empty group: #{old_folder}"
    old_dir = File.join(base_dir, old_folder)
    FileUtils.rm_rf(old_dir) if Dir.exist?(old_dir) && Dir.empty?(old_dir)
  end
end

project.save
puts "Successfully saved Xcode project."
