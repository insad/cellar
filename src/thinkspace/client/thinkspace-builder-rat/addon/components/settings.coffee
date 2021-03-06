import ember from 'ember'
import base  from 'thinkspace-base/components/base'

###
# # settings.coffee
- Type: **Component**
- Package: **thinkspace-builder-rat**
###
export default base.extend

  builder: ember.inject.service()

  step:    ember.computed.reads 'builder.current_step'

  # ## Actions
  actions:
    prev_step: -> @get('builder').transition_to_prev_step(save: true)
    next_step: -> @get('builder').transition_to_next_step(save: true)
    exit: -> @get('builder').transition_to_cases_show()