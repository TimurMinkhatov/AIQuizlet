geko generate
python3 /tmp/fix_moya.py
mkdir -p Geko/Dependencies/Sources
rm -rf Geko/Dependencies/Sources/Moya
ln -s $(pwd)/Geko/Dependencies/Cocoapods/Moya/Sources/Moya Geko/Dependencies/Sources/Moya
ln -sf $(pwd)/Geko/Dependencies/Cocoapods/Moya/Sources/Moya/Plugins/AccessTokenPlugin.swift Geko/Dependencies/Sources/Moya/AccessTokenPlugin.swift
ln -sf $(pwd)/Geko/Dependencies/Cocoapods/Moya/Sources/Moya/Plugins/CredentialsPlugin.swift Geko/Dependencies/Sources/Moya/CredentialsPlugin.swift
ln -sf $(pwd)/Geko/Dependencies/Cocoapods/Moya/Sources/Moya/Plugins/NetworkActivityPlugin.swift Geko/Dependencies/Sources/Moya/NetworkActivityPlugin.swift
ln -sf $(pwd)/Geko/Dependencies/Cocoapods/Moya/Sources/Moya/Plugins/NetworkLoggerPlugin.swift Geko/Dependencies/Sources/Moya/NetworkLoggerPlugin.swift
