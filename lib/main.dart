import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Registro {
  late String nombre;
  late DateTime fechaHora;
  late List<String> opcionesSeleccionadas;

  Registro({
    required this.nombre,
    required this.fechaHora,
    required this.opcionesSeleccionadas,
  });
}

class Alumno {
  late String nombre;
  late String materia;

  Alumno({
    required this.nombre,
    required this.materia,
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
  final TextEditingController _nombreController = TextEditingController();
  List<String> _opcionesSeleccionadas = [];
  List<Registro> _registros = [];
  List<Alumno> _alumnos = [];

  void _guardarRegistro() {
    String nombre = _nombreController.text;
    DateTime now = DateTime.now();
    Registro nuevoRegistro = Registro(
      nombre: nombre,
      fechaHora: now,
      opcionesSeleccionadas: List.from(_opcionesSeleccionadas),
    );

    setState(() {
      _registros.add(nuevoRegistro);
      _nombreController.clear();
      _opcionesSeleccionadas.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registro guardado')),
    );
  }

  void _registrarAlumno(String nombre, String materia) {
    setState(() {
      _alumnos.add(Alumno(nombre: nombre, materia: materia));
    });
  }

  void _eliminarAlumno(int index) {
    setState(() {
      _alumnos.removeAt(index);
    });
  }

  void _eliminarRegistro(int index) {
    setState(() {
      _registros.removeAt(index);
    });
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
              leading: Icon(Icons.person_add),
              title: Text('Registro de Alumnos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistroAlumnosPage(
                      alumnos: _alumnos,
                      registrarAlumno: _registrarAlumno,
                      eliminarAlumno: _eliminarAlumno,
                    ),
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
                          .map((registro) => AsistenciaMaestro(
                                nombre: registro.nombre,
                                fechaHora: registro.fechaHora,
                              ))
                          .toList(),
                      eliminarRegistro: _eliminarRegistro,
                    ),
                  ),
                );
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
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre del maestro'),
            ),
            SizedBox(height: 16.0),
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
                  title: Text('Maestro: ${registro.nombre}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha y Hora: ${registro.fechaHora}'),
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
                  title: Text('Maestro: ${registro.nombre}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha y Hora: ${registro.fechaHora}'),
                      Text('Asistencia: ${registro.opcionesSeleccionadas.join(', ')}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class RegistroAlumnosPage extends StatefulWidget {
  final List<Alumno> alumnos;
  final Function(String, String) registrarAlumno;
  final Function(int) eliminarAlumno;

  RegistroAlumnosPage({
    required this.alumnos,
    required this.registrarAlumno,
    required this.eliminarAlumno,
  });

  @override
  _RegistroAlumnosPageState createState() => _RegistroAlumnosPageState();
}

class _RegistroAlumnosPageState extends State<RegistroAlumnosPage> {
  late String _nombre = '';
  late String _materia = '';

  @override
  Widget build(BuildContext context) {
    Map<String, List<Alumno>> alumnosPorMateria = {};

    for (var alumno in widget.alumnos) {
      if (!alumnosPorMateria.containsKey(alumno.materia)) {
        alumnosPorMateria[alumno.materia] = [];
      }
      alumnosPorMateria[alumno.materia]!.add(alumno);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Alumnos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) => _nombre = value,
              decoration: InputDecoration(labelText: 'Nombre del alumno'),
            ),
            TextFormField(
              onChanged: (value) => _materia = value,
              decoration: InputDecoration(labelText: 'Materia'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                widget.registrarAlumno(_nombre, _materia);
                setState(() {
                  _nombre = '';
                  _materia = '';
                });
              },
              child: Text('Registrar Alumno'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Alumnos Registrados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: alumnosPorMateria.length,
                itemBuilder: (context, index) {
                  String materia = alumnosPorMateria.keys.elementAt(index);
                  List<Alumno> alumnosMateria = alumnosPorMateria[materia]!;
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            materia,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: alumnosMateria.length,
                          itemBuilder: (context, index) {
                            Alumno alumno = alumnosMateria[index];
                            return ListTile(
                              title: Text(alumno.nombre),
                              subtitle: Text('Materia: ${alumno.materia}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => widget.eliminarAlumno(index),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AsistenciaMaestroPage extends StatelessWidget {
  final List<AsistenciaMaestro> asistencias;
  final Function(int) eliminarRegistro;

  AsistenciaMaestroPage({required this.asistencias, required this.eliminarRegistro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencia Entrada y Salida'),
      ),
      body: Column(
        children: [
          Expanded(
            child: asistencias.isEmpty
                ? Center(child: Text('No hay registros de asistencia de maestros'))
                : ListView.builder(
                    itemCount: asistencias.length,
                    itemBuilder: (context, index) {
                      AsistenciaMaestro asistencia = asistencias[index];
                      return ListTile(
                        title: Text('Maestro: ${asistencia.nombre}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fecha y Hora: ${asistencia.fechaHora}'),
                            Text(
                              'ASISTENCIA REGISTRADA',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => eliminarRegistro(index),
                              child: Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AsistenciaMaestro {
  final String nombre;
  final DateTime fechaHora;

  AsistenciaMaestro({required this.nombre, required this.fechaHora});
}

