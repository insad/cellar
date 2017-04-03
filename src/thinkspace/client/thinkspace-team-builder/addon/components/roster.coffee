import ember            from 'ember'
import ns               from 'totem/ns'
import base_component   from 'thinkspace-base/components/base'
import student_row      from 'thinkspace-team-builder/mixins/rows/student'
import column           from 'thinkspace-common/table/column'
import selectable_mixin from 'thinkspace-common/mixins/table/cells/selectable'

export default base_component.extend selectable_mixin,

  manager: ember.inject.service()

  teams:     ember.computed.reads 'manager.teams'
  team_set:  ember.computed.reads 'manager.team_set'
  abstract:  ember.computed.reads 'manager.abstract'
  users:     ember.computed.reads 'abstract.users'

  empty: ember.computed.empty 'teams'

  selected_team: null
  
  columns: ember.computed 'manager', 'model', ->
    [
      column.create({display: 'Select', component: '__table/cells/selectable', data: {calling: @}}),
      column.create({display: 'Last Name',  property: 'last_name'})
      column.create({display: 'First Name', property: 'first_name'}),
      column.create({display: 'Team',       property: 'computed_title'}),
    ]

  init_base: ->
    @init_table_data()
    @set_all_data_loaded()

  generate_dummy_model: ->
    obj            = {}
    obj.first_name = Math.random().toString(36).substring(7)
    obj.last_name  = Math.random().toString(36).substring(7)
    obj.team_id    = 1
    obj

  get_test_students: ->
    rows    = []
    manager = @get('manager')
    for i in [0..1000]
      row = student_row.create(model: @generate_dummy_model(), manager: manager)
      rows.pushObject(row)
    rows

  get_students: ->
    rows    = []
    users   = @get('users')
    manager = @get('manager')
    users.forEach (user) =>
      row = student_row.create(model: user, manager: manager)
      rows.pushObject(row)
    rows

  init_table_data: ->
    users   = @get('users')
    manager = @get('manager')
    #rows    = @get_test_students()
    rows = @get_students()
    @set('rows', rows)

  ## Needs to be called to ensure that changes to the transform are reflected
  refresh: ->
    @init_table_data()

  actions:

    add_to_team: (team) ->
      @set('selected_team', team)
      manager = @get('manager')
      @get('selected_rows').forEach (row) =>
        user = row.get('model')
        manager.add_to_team(team.id, user)
      manager.save_transform().then =>
        #manager.reconcile_assigned_users()
        @refresh()

