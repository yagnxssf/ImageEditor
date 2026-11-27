# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'ImageEditor' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for ImageEditor
pod 'TZImagePickerController'
pod 'Masonry', '~> 1.1.0'
pod 'MBProgressHUD'

end

post_install do |installer|
  # iOS 26 SDK 起 PHAssetCollectionSubtypeAlbumRegular(=2) 不再被 Photos 接受为
  # SmartAlbum(=2) 的 subtype，该 fetch 会返回空导致选择器丢失「所有照片」等智能相册。
  manager = installer.sandbox.root.join(
    'TZImagePickerController/TZImagePickerController/TZImagePickerController/TZImageManager.m')
  unless manager.exist?
    Pod::UI.puts "post_install: #{manager} not found, TZImagePickerController patch skipped"
    next
  end

  source = File.read(manager)
  patched = source.gsub(
    'PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular',
    'PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny')
  File.write(manager, patched)
  Pod::UI.puts "post_install: patched TZImageManager.m smart album fetches"
end
