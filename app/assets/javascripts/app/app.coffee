Ext.Loader.setPath
  'Ext': 'assets/touch/src'
  'Superfit': 'assets/app'


Ext.application
  name: 'Superfit'
  controllers: ['Main','EnterWOD']
  views: ['Main', 'EnterWOD']
  launch: () ->
    Ext.create('Superfit.view.Main');
    Ext.Viewport.add(xtype: 'enterWOD')
