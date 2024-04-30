import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Registro {
  late DateTime fechaHora;
  late List<String> opcionesSeleccionadas;

  Registro({
    required this.fechaHora,
    required this.opcionesSeleccionadas,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Asistencia',
      home: RegistroPage(),
    );
  }
}

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  List<String> _opcionesSeleccionadas = [];
  List<Registro> _registros = [];

  void _guardarRegistro() {
    DateTime now = DateTime.now();
    Registro nuevoRegistro = Registro(
      fechaHora: now,
      opcionesSeleccionadas: List.from(_opcionesSeleccionadas),
    );

    setState(() {
      _registros.add(nuevoRegistro);
      _opcionesSeleccionadas.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registro guardado')),
    );
  }

  void _mostrarDialogoDeBusqueda(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar en el Registro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Ingrese el término de búsqueda'),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    // Buscar la opción ingresada y dirigir al usuario a esa página
                    switch (value.toLowerCase()) {
                      case 'consulta de asistencia':
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultaAsistenciaPage(registros: _registros),
                          ),
                        );
                        break;
                      case 'consulta de inasistencias':
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultaInasistenciaPage(registros: _registros),
                          ),
                        );
                        break;
                      case 'asistencia entrada y salida':
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AsistenciaMaestroPage(
                              asistencias: _registros
                                  .where((registro) => registro.opcionesSeleccionadas.contains('Presente'))
                                  .map((registro) => Registro(
                                        fechaHora: registro.fechaHora,
                                        opcionesSeleccionadas: registro.opcionesSeleccionadas,
                                      ))
                                  .toList(),
                            ),
                          ),
                        );
                        break;
                      default:
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('La opción ingresada no existe')),
                        );
                        break;
                    }
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // No es necesario realizar acciones adicionales aquí ya que la lógica está en el onFieldSubmitted
                Navigator.pop(context);
              },
              child: Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Asistencia'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Opciones',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Consulta de Asistencia'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsultaAsistenciaPage(registros: _registros),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.warning),
              title: Text('Consulta de Inasistencias'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConsultaInasistenciaPage(registros: _registros),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note),
              title: Text('Asistencia Entrada y Salida'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AsistenciaMaestroPage(
                      asistencias: _registros
                          .where((registro) => registro.opcionesSeleccionadas.contains('Presente'))
                          .map((registro) => Registro(
                                fechaHora: registro.fechaHora,
                                opcionesSeleccionadas: registro.opcionesSeleccionadas,
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Filtro de Búsqueda'),
              onTap: () {
                Navigator.pop(context);
                _mostrarDialogoDeBusqueda(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selecciona las opciones:'),
            CheckboxListTile(
              title: Text('Presente'),
              value: _opcionesSeleccionadas.contains('Presente'),
              onChanged: (value) {
                setState(() {
                  if (value!)
                    _opcionesSeleccionadas.add('Presente');
                  else
                    _opcionesSeleccionadas.remove('Presente');
                });
              },
            ),
            CheckboxListTile(
              title: Text('Retrasado'),
              value: _opcionesSeleccionadas.contains('Retrasado'),
              onChanged: (value) {
                setState(() {
                  if (value!)
                    _opcionesSeleccionadas.add('Retrasado');
                  else
                    _opcionesSeleccionadas.remove('Retrasado');
                });
              },
            ),
            CheckboxListTile(
              title: Text('Excusado'),
              value: _opcionesSeleccionadas.contains('Excusado'),
              onChanged: (value) {
                setState(() {
                  if (value!)
                    _opcionesSeleccionadas.add('Excusado');
                  else
                    _opcionesSeleccionadas.remove('Excusado');
                });
              },
            ),
            CheckboxListTile(
              title: Text('Ausente'),
              value: _opcionesSeleccionadas.contains('Ausente'),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    _opcionesSeleccionadas.add('Ausente');
                    _opcionesSeleccionadas.remove('Presente');
                    _opcionesSeleccionadas.remove('Retrasado');
                    _opcionesSeleccionadas.remove('Excusado');
                  } else {
                    _opcionesSeleccionadas.remove('Ausente');
                  }
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _guardarRegistro,
              child: Text('Guardar Registro'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsultaAsistenciaPage extends StatelessWidget {
  final List<Registro> registros;

  ConsultaAsistenciaPage({required this.registros});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Asistencia'),
      ),
      body: registros.isEmpty
          ? Center(child: Text('No hay registros de asistencia'))
          : ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                Registro registro = registros[index];
                return ListTile(
                  title: Text('Fecha y Hora: ${registro.fechaHora}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Asistencia: ${registro.opcionesSeleccionadas.join(', ')}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class ConsultaInasistenciaPage extends StatelessWidget {
  final List<Registro> registros;

  ConsultaInasistenciaPage({required this.registros});

  @override
  Widget build(BuildContext context) {
    List<Registro> inasistencias =
        registros.where((registro) => registro.opcionesSeleccionadas.contains('Ausente')).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Inasistencias'),
      ),
      body: inasistencias.isEmpty
          ? Center(child: Text('No hay registros de inasistencias'))
          : ListView.builder(
              itemCount: inasistencias.length,
              itemBuilder: (context, index) {
                Registro registro = inasistencias[index];
                return ListTile(
                  title: Text('Fecha y Hora: ${registro.fechaHora}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Asistencia: ${registro.opcionesSeleccionadas.join(', ')}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class AsistenciaMaestroPage extends StatelessWidget {
  final List<Registro> asistencias;

  AsistenciaMaestroPage({required this.asistencias});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencia Entrada y Salida'),
      ),
      body: asistencias.isEmpty
          ? Center(child: Text('No hay registros de asistencia de maestros'))
          : ListView.builder(
              itemCount: asistencias.length,
              itemBuilder: (context, index) {
                Registro asistencia = asistencias[index];
                return ListTile(
                  title: Text('Fecha y Hora: ${asistencia.fechaHora}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Asistencia: ${asistencia.opcionesSeleccionadas.join(', ')}'),
                      if (asistencia.opcionesSeleccionadas.contains('Presente'))
                        Text(
                          'Asistencia registrada',
                          style: TextStyle(color: Colors.green),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
