# encoding: utf-8

::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = "oty9RerOy-rOdvkiI9YPnLNeqJP4tJ0I3SjW9UqJ"
  config.qiniu_secret_key    = 'zaKg0_T_DmVHRheE3DWx1ZAZohHEEVz4Q5gxaNr5'
  config.qiniu_bucket        = "jieshuquan-ios"
  config.qiniu_bucket_domain = "jieshuquan-ios.qiniudn.com"
  config.expires_in = 0
end