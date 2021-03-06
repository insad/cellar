import ember from 'ember'
import base  from 'thinkspace-base/components/base'

###
# # content.coffee
- Type: **Component**
- Package: **thinkspace-builder-rat**
###
export default base.extend

  builder: ember.inject.service()

  actions:
    select_release_at: (date) -> @get('step').select_release_at(date)
    select_due_at:     (date) -> @get('step').select_due_at(date)
    select_unlock_at:  (date) -> @get('step').select_unlock_at(date)

    toggle_is_ifat:     -> @get('step').toggle_is_ifat()
    toggle_is_req_just: -> @get('step').toggle_is_req_just()