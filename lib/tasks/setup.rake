task setup: ['db:create', 'db:migrate', 'db:seed']
task resetup: ['db:drop', 'setup']