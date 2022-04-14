# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!
source 'https://cdn.cocoapods.org/'
#install! 'cocoapods',
#         :generate_multiple_pod_projects => true,
#         :incremental_installation => true
#plugin 'cocoapods-binary'
#use_frameworks! :linkage => :static
#keep_source_code_for_prebuilt_frameworks!
#enable_bitcode_for_prebuilt_frameworks!

target 'Monitor' do
  inhibit_all_warnings!
  pod 'Action'      #,  :binary=>true
  pod 'RxCocoa'     #,  :binary=>true
  pod 'RxSwift'     #,  :binary=>true
  pod 'SnapKit'     #,  :binary=>true
  pod 'NSObject+Rx' #,  :binary=>true
  pod 'XCoordinator'#,  :binary=>true
  pod 'Then'
  pod 'Toast-Swift'
  
  pod 'LookinServer', :configurations => ['Debug'] #UI调试工具：https://lookin.work
  pod 'FLEX', :configurations => ['Debug']
  pod 'SwiftTweaks'
end

