%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt,
  app/controllers/v1/
].each { |path| Spring.watch(path) }
