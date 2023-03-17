# Since this gem is only loaded with the assets group, we have to check to
# see if it's defined before configuring it.
if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_provider = 'AWS'
    config.aws_access_key_id = ENV["AWS_ROR_ACCESS_KEY_ID"]
    config.aws_secret_access_key = ENV["AWS_ROR_ACCESS_KEY_SECRET"]
    config.fog_directory = 'vidanutriscience'
    config.fog_region = 'ap-southeast-1'

    # Don't delete files from the store
    config.existing_remote_files = 'delete'

    # Automatically replace files with their equivalent gzip compressed version
    config.gzip_compression = true

    # Use the Rails generated 'manifest.yml' file to produce the list of files to
    # upload instead of searching the assets directory.
    # config.manifest = true

    # Fail silently.  Useful for environments such as Heroku
    config.fail_silently = true
  end
end
