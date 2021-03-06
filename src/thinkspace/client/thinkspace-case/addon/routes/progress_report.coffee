import ember from 'ember'
import ns    from 'totem/ns'
import base  from 'thinkspace-base/routes/base'

export default base.extend

  titleToken: (model) -> model.get('title')

  model: (params) -> @tc.find_record_with_message ns.to_p('assignment'), params.assignment_id
