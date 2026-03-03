import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MiHorarioApp());
}

class MiHorarioApp extends StatelessWidget {
  const MiHorarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0E20),
        cardColor: const Color(0xFF2D1C7F),
        primaryColor: const Color(0xFF7546E8),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7546E8),
          secondary: Color(0xFFC8B3F6),
          surface: Color(0xFF2D1C7F),
        ),
        useMaterial3: true,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

class Sesion {
  String dia;
  TimeOfDay inicio;
  TimeOfDay fin;
  String aula;

  Sesion({required this.dia, required this.inicio, required this.fin, required this.aula});

  Sesion clone() => Sesion(dia: dia, inicio: inicio, fin: fin, aula: aula);
}

class Materia {
  String id;
  String nombre;
  String maestro;
  String notas;
  Color color;
  List<Sesion> sesiones;

  Materia({
    required this.id,
    required this.nombre,
    this.maestro = '',
    this.notas = '',
    required this.color,
    required this.sesiones,
  });

  Materia clone() => Materia(
    id: id,
    nombre: nombre,
    maestro: maestro,
    notas: notas,
    color: color,
    sesiones: sesiones.map((s) => s.clone()).toList(),
  );
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  List<Materia> misMaterias = [];
  bool esPrimeraVez = true;
  bool esVistaSemanal = false;
  String diaFiltrado = _obtenerDiaActual();

  static String _obtenerDiaActual() {
    List<String> dias = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"];
    int index = DateTime.now().weekday - 1;
    return (index >= 0 && index < 6) ? dias[index] : dias[0];
  }

  void _guardarMateria(Materia mForm) {
    setState(() {
      int index = misMaterias.indexWhere((m) => m.id == mForm.id);
      if (index >= 0) {
        misMaterias[index] = mForm;
      } else {
        misMaterias.add(mForm);
      }
      esPrimeraVez = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (esPrimeraVez && misMaterias.isEmpty) {
      return _buildBienvenida();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(esVistaSemanal ? "Horario Semanal" : "Horario de Hoy"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(esVistaSemanal ? Icons.calendar_view_day : Icons.grid_view_rounded),
            onPressed: () => setState(() => esVistaSemanal = !esVistaSemanal),
          )
        ],
        bottom: esVistaSemanal ? null : PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _selectorDeDias(),
        ),
      ),
      body: esVistaSemanal ? _buildVistaSemanal() : _buildListaHorario(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7546E8),
        onPressed: () => _abrirFormularioCentrado(context),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildBienvenida() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_rounded, size: 100, color: Color(0xFF7546E8)),
            const SizedBox(height: 20),
            const Text("¡Bienvenido!", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Crea tu primer horario para comenzar"),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7546E8)),
              onPressed: () => _abrirFormularioCentrado(context),
              child: const Text("Empezar", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _selectorDeDias() {
    List<String> dias = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: dias.map((d) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(d),
            selected: diaFiltrado == d,
            onSelected: (s) => setState(() => diaFiltrado = d),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildListaHorario() {
    List<Widget> cards = [];
    for (var m in misMaterias) {
      for (var s in m.sesiones) {
        if (s.dia == diaFiltrado) {
          cards.add(_tarjetaMateria(m, s));
        }
      }
    }
    return cards.isEmpty 
      ? const Center(child: Text("No hay clases hoy")) 
      : ListView(children: cards);
  }

  Widget _tarjetaMateria(Materia m, Sesion s) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      color: m.color.withOpacity(0.9),
      child: ListTile(
        title: Text(m.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Aula: ${s.aula}\n${s.inicio.format(context)} - ${s.fin.format(context)}"),
        trailing: const Icon(Icons.info_outline),
        onTap: () => _mostrarDetalles(context, m),
      ),
    );
  }

  Widget _buildVistaSemanal() {
    List<String> dias = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dias.map((d) => Container(
          width: MediaQuery.of(context).size.width * 0.45,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(color: const Color(0xFF2D1C7F).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFF7546E8), borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                child: Text(d, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ..._obtenerMiniCards(d),
            ],
          ),
        )).toList(),
      ),
    );
  }

  List<Widget> _obtenerMiniCards(String dia) {
    List<Widget> list = [];
    for (var m in misMaterias) {
      for (var s in m.sesiones) {
        if (s.dia == dia) {
          list.add(GestureDetector(
            onTap: () => _mostrarDetalles(context, m),
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: m.color.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.nombre, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Text("${s.inicio.format(context)} - ${s.aula}", style: const TextStyle(fontSize: 9)),
                ],
              ),
            ),
          ));
        }
      }
    }
    return list;
  }

  void _mostrarDetalles(BuildContext context, Materia m) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(m.nombre),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Maestro: ${m.maestro}"),
              Text("Notas: ${m.notas}"),
              const Divider(),
              ...m.sesiones.map((s) => Text("${s.dia}: ${s.inicio.format(context)} a ${s.fin.format(context)} [${s.aula}]")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
          ElevatedButton(onPressed: () { Navigator.pop(context); _abrirFormularioCentrado(context, mParaEditar: m); }, child: const Text("Editar")),
        ],
      ),
    );
  }

  void _abrirFormularioCentrado(BuildContext context, {Materia? mParaEditar}) {
    Materia mForm = mParaEditar != null ? mParaEditar.clone() : Materia(
      id: DateTime.now().toString(),
      nombre: '',
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      sesiones: [],
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setST) {
          return AlertDialog(
            title: Text(mParaEditar == null ? "Nueva Materia" : "Editar Materia"),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: TextEditingController(text: mForm.nombre)..selection = TextSelection.collapsed(offset: mForm.nombre.length),
                      decoration: const InputDecoration(labelText: "Nombre"),
                      onChanged: (v) => mForm.nombre = v,
                    ),
                    TextField(
                      controller: TextEditingController(text: mForm.maestro)..selection = TextSelection.collapsed(offset: mForm.maestro.length),
                      decoration: const InputDecoration(labelText: "Maestro"),
                      onChanged: (v) => mForm.maestro = v,
                    ),
                    TextField(
                      controller: TextEditingController(text: mForm.notas)..selection = TextSelection.collapsed(offset: mForm.notas.length),
                      decoration: const InputDecoration(labelText: "Notas"),
                      onChanged: (v) => mForm.notas = v,
                    ),
                    const SizedBox(height: 10),
                    _buildColorPicker(mForm, setST),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Horarios"),
                        IconButton(icon: const Icon(Icons.add_circle), onPressed: () => setST(() => mForm.sesiones.add(Sesion(dia: 'Lunes', inicio: TimeOfDay.now(), fin: TimeOfDay.now(), aula: '')))),
                      ],
                    ),
                    ...mForm.sesiones.asMap().entries.map((e) => _buildSesionEdit(e.value, e.key, mForm, setST)),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
              ElevatedButton(onPressed: () { if (mForm.nombre.isNotEmpty) { _guardarMateria(mForm); Navigator.pop(context); } }, child: const Text("Guardar")),
            ],
          );
        },
      ),
    );
  }

  Widget _buildColorPicker(Materia m, StateSetter setST) {
    List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors.map((c) => GestureDetector(
        onTap: () => setST(() => m.color = c),
        child: Container(
          margin: const EdgeInsets.all(4),
          width: 25, height: 25,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: m.color.value == c.value ? Border.all(color: Colors.white, width: 2) : null),
        ),
      )).toList(),
    );
  }

  Widget _buildSesionEdit(Sesion s, int i, Materia m, StateSetter setST) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: DropdownButton<String>(
              value: s.dia,
              items: ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setST(() => s.dia = v!),
            )),
            IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () => setST(() => m.sesiones.removeAt(i))),
          ],
        ),
        Row(
          children: [
            TextButton(child: Text(s.inicio.format(context)), onPressed: () async { var t = await showTimePicker(context: context, initialTime: s.inicio); if (t != null) setST(() => s.inicio = t); }),
            const Text("-"),
            TextButton(child: Text(s.fin.format(context)), onPressed: () async { var t = await showTimePicker(context: context, initialTime: s.fin); if (t != null) setST(() => s.fin = t); }),
            Expanded(child: TextField(decoration: const InputDecoration(hintText: "Aula"), onChanged: (v) => s.aula = v)),
          ],
        ),
        const Divider(),
      ],
    );
  }
}