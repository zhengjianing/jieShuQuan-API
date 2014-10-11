::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = "YX8NmEu7UJmewEUCLLixW4ZfKxAfg_20sZhhVS7b"
  config.qiniu_secret_key    = 'o2tBq4RUtP9fuOVt-5K3fnp_WSQ3QfD8ddzwsZC2 '
  config.qiniu_bucket        = "jieshuquan"
  config.qiniu_bucket_domain = "jieshuquan.qiniudn.com"
  config.qiniu_bucket_private= true
  config.qiniu_block_size    = 4*1024*1024
  config.qiniu_protocol      = "http"
end