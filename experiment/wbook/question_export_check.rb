require "./setup"
require "pp"

User.delete_all
Wbook.destroy_all
Wbook.setup

# user1 = User.sysop
# 
# question = user1.wbook_questions.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
#   e.moves_answers.build(moves_str: "G*4b")
#   e.moves_answers.build(moves_str: "G*5b")
#   e.moves_answers.build(moves_str: "G*6b")
#   e.time_limit_sec    = 60 * 3
#   e.difficulty_level  = 5
#   e.title             = "(title)"
#   e.description       = "(description)"
#   e.hint_desc         = "(hint_desc)"
#   e.source_author      = "(source_author)"
# end
# 
# Wbook::Question.export_all
# 
# User.delete_all
# Wbook.destroy_all
# Wbook.setup

Wbook::Question.export_all
Wbook::Question.import_all
# ~> /Users/ikeda/src/shogi-extend/app/models/concerns/memory_record_bind.rb:51:in `rescue in fetch': Wbook::Judge.fetch(:pending) (ArgumentError)
# ~> keys: []
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/memory_record_bind.rb:44:in `fetch'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/wbook/xrecord_share_mod.rb:69:in `block (3 levels) in <module:Wbook>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `block in make_lambda'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:200:in `block (2 levels) in halting'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:605:in `block (2 levels) in default_terminator'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:604:in `catch'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:604:in `block in default_terminator'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:201:in `block in halting'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:513:in `block in invoke_before'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:513:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:513:in `invoke_before'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:134:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:825:in `_run_validation_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.0.3.2/lib/active_model/validations/callbacks.rb:117:in `run_validations!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.0.3.2/lib/active_model/validations.rb:337:in `valid?'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/validations.rb:68:in `valid?'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/validations.rb:84:in `perform_validations'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/validations.rb:47:in `save'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:314:in `block in save'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:375:in `block in with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/database_statements.rb:278:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:212:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:366:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:314:in `save'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/suppressor.rb:44:in `save'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/singular_association.rb:52:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/has_one_association.rb:114:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/association.rb:199:in `create!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/builder/singular_association.rb:37:in `create_wbook_main_xrecord!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/wbook/user_mod.rb:180:in `block (3 levels) in <module:UserMod>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `block in make_lambda'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:238:in `block in halting_and_conditional'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:517:in `block in invoke_after'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:517:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:517:in `invoke_after'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:136:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:825:in `_run_create_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/callbacks.rb:331:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/timestamp.rb:110:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/persistence.rb:905:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/callbacks.rb:327:in `block in create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:135:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:825:in `_run_save_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/callbacks.rb:327:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/timestamp.rb:128:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/persistence.rb:503:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/validations.rb:53:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:318:in `block in save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:375:in `block in with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `block in transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/transaction.rb:280:in `block in within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:26:in `block (2 levels) in synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/transaction.rb:278:in `within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:212:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:366:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:318:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/suppressor.rb:48:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/persistence.rb:55:in `create!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/user_staff_mod.rb:21:in `staff_create!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/user_staff_mod.rb:8:in `sysop'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/wbook/question/import_export_mod.rb:51:in `import_all'
# ~> 	from -:30:in `<main>'
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/core.rb:211:in `find_by!': Couldn't find Wbook::Judge (ActiveRecord::RecordNotFound)
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/memory_record_bind.rb:48:in `fetch'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/wbook/xrecord_share_mod.rb:69:in `block (3 levels) in <module:Wbook>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `block in make_lambda'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:200:in `block (2 levels) in halting'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:605:in `block (2 levels) in default_terminator'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:604:in `catch'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:604:in `block in default_terminator'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:201:in `block in halting'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:513:in `block in invoke_before'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:513:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:513:in `invoke_before'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:134:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:825:in `_run_validation_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.0.3.2/lib/active_model/validations/callbacks.rb:117:in `run_validations!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.0.3.2/lib/active_model/validations.rb:337:in `valid?'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/validations.rb:68:in `valid?'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/validations.rb:84:in `perform_validations'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/validations.rb:47:in `save'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:314:in `block in save'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:375:in `block in with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/database_statements.rb:278:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:212:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:366:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:314:in `save'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/suppressor.rb:44:in `save'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/singular_association.rb:52:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/has_one_association.rb:114:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/association.rb:199:in `create!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/associations/builder/singular_association.rb:37:in `create_wbook_main_xrecord!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/wbook/user_mod.rb:180:in `block (3 levels) in <module:UserMod>'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `instance_exec'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:428:in `block in make_lambda'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:238:in `block in halting_and_conditional'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:517:in `block in invoke_after'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:517:in `each'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:517:in `invoke_after'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:136:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:825:in `_run_create_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/callbacks.rb:331:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/timestamp.rb:110:in `_create_record'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/persistence.rb:905:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/callbacks.rb:327:in `block in create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:135:in `run_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/callbacks.rb:825:in `_run_save_callbacks'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/callbacks.rb:327:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/timestamp.rb:128:in `create_or_update'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/persistence.rb:503:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/validations.rb:53:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:318:in `block in save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:375:in `block in with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `block in transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/transaction.rb:280:in `block in within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:26:in `block (2 levels) in synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `handle_interrupt'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:25:in `block in synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `handle_interrupt'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activesupport-6.0.3.2/lib/active_support/concurrency/load_interlock_aware_monitor.rb:21:in `synchronize'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/transaction.rb:278:in `within_new_transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/connection_adapters/abstract/database_statements.rb:280:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:212:in `transaction'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:366:in `with_transaction_returning_status'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/transactions.rb:318:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/suppressor.rb:48:in `save!'
# ~> 	from /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activerecord-6.0.3.2/lib/active_record/persistence.rb:55:in `create!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/user_staff_mod.rb:21:in `staff_create!'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/concerns/user_staff_mod.rb:8:in `sysop'
# ~> 	from /Users/ikeda/src/shogi-extend/app/models/wbook/question/import_export_mod.rb:51:in `import_all'
# ~> 	from -:30:in `<main>'
# >> write: /Users/ikeda/src/shogi-extend/app/models/wbook/questions.yml (0)
