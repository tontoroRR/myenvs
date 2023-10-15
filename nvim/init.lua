print ('init lua read')

require('options')

-- lazy load plugins
require('lazy_nvim')
require('lazy').setup(require('lazy_plugins'))

-- other plugins
-- require('plugins')
