import 'package:flutter/material.dart';

void main() => runApp(const MiHorarioApp());

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
        useMaterial3: true,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

class Sesion {
  String dia;
  double horaInicio; 
  double horaFin;
  String aula;
  Sesion({required this.dia, required this.horaInicio, required this.horaFin, required this.aula});
}

class Materia {
  String nombre, maestro;
  Color color;
  List<Sesion> sesiones;
  Materia({required this.nombre, required this.maestro, required this.color, required this.sesiones});
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});
  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final double altoHora = 80.0; 
  final double anchoDia = 150.0;
  final double anchoHoraCol = 65.0;
  final int horaInicioTabla = 7; 
  final int totalHoras = 13; 

  bool esVistaSemanal = true;
  final List<String> dias = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes"];
  
  late PageController _pageController;
  late List<Materia> misMaterias;

  @override
  void initState() {
    super.initState();
    int initialPage = DateTime.now().weekday - 1;
    if (initialPage > 4) initialPage = 0;
    _pageController = PageController(initialPage: initialPage);

    misMaterias = [
      Materia(
        nombre: "TALLER DE INVESTIGACIÓN I",
        maestro: "Mtro. Armando Cetina",
        color: const Color(0xFFE91E63),
        sesiones: [
          Sesion(dia: "Martes", horaInicio: 10.0, horaFin: 12.0, aula: "H12"),
          Sesion(dia: "Jueves", horaInicio: 11.0, horaFin: 13.0, aula: "LCOM4"),
        ],
      ),
      Materia(
        nombre: "DESARROLLO DE BACK-END",
        maestro: "Mtro. RODRIGO FIDEL GAXIOLA SOSA",
        color: const Color(0xFF00BCD4),
        sesiones: [
          Sesion(dia: "Miércoles", horaInicio: 9.0, horaFin: 11.0, aula: "H8"),
          Sesion(dia: "Viernes", horaInicio: 10.0, horaFin: 13.0, aula: "H10"),
        ],
      ),
      Materia(
        nombre: "PROGRAMACIÓN DE MÓVILES",
        maestro: "Mtra. SARA NELLY MORENO CIMÉ",
        color: const Color(0xFFFF9800),
        sesiones: [
          Sesion(dia: "Martes", horaInicio: 14.0, horaFin: 17.0, aula: "H2"),
          Sesion(dia: "Jueves", horaInicio: 14.0, horaFin: 16.0, aula: "H8"),
        ],
      ),
      Materia(
        nombre: "GESTIÓN ÁGIL DE PROYECTOS",
        maestro: "Mtro. MARIO RENÁN MORENO SABIDO",
        color: const Color(0xFF4CAF50),
        sesiones: [
          Sesion(dia: "Miércoles", horaInicio: 13.0, horaFin: 16.0, aula: "H11"),
          Sesion(dia: "Viernes", horaInicio: 13.0, horaFin: 15.0, aula: "H11"),
        ],
      ),
      Materia(
        nombre: "ADMINISTRACIÓN DE REDES",
        maestro: "Mtro. BRAULIO AZAAF PAZ GARCIA",
        color: const Color(0xFF7546E8),
        sesiones: [
          Sesion(dia: "Lunes", horaInicio: 16.0, horaFin: 18.0, aula: "H2"),
          Sesion(dia: "Viernes", horaInicio: 15.0, horaFin: 17.0, aula: "H2"),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _irAHoy() {
    int hoy = DateTime.now().weekday - 1;
    if (hoy > 4) hoy = 0;
    if (!esVistaSemanal) {
      _pageController.animateToPage(hoy, 
        duration: const Duration(milliseconds: 400), 
        curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esVistaSemanal ? "Horario Semanal" : "Vista Diaria"),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0E20),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(esVistaSemanal ? Icons.calendar_view_day : Icons.grid_on),
            onPressed: () => setState(() => esVistaSemanal = !esVistaSemanal),
          )
        ],
      ),
      body: esVistaSemanal ? _buildVistaSemanal() : _buildVistaDiariaSwipe(),
      floatingActionButton: !esVistaSemanal ? FloatingActionButton.extended(
        onPressed: _irAHoy,
        backgroundColor: const Color(0xFF7546E8),
        icon: const Icon(Icons.today, color: Colors.white),
        label: const Text("Hoy", style: TextStyle(color: Colors.white)),
      ) : null,
    );
  }

  Widget _buildVistaSemanal() {
    return InteractiveViewer(
      constrained: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: anchoHoraCol),
              ...dias.map((d) => Container(
                    width: anchoDia,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D1C7F).withValues(alpha: 0.3),
                      border: Border(
                        bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 2),
                        right: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Text(d, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC8B3F6))),
                  )),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildColumnaHoras(),
              ...dias.map((d) => _buildColumnaDia(d)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumnaHoras() {
    return Column(
      children: List.generate(totalHoras, (i) {
        return Container(
          height: altoHora,
          width: anchoHoraCol,
          padding: const EdgeInsets.only(right: 12),
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1)),
          ),
          child: Text("${horaInicioTabla + i}:00", style: const TextStyle(fontSize: 12, color: Colors.white70)),
        );
      }),
    );
  }

  Widget _buildColumnaDia(String dia) {
    return Container(
      width: anchoDia,
      height: altoHora * totalHoras,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.white.withValues(alpha: 0.15), width: 1)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...List.generate(totalHoras, (i) => Positioned(
            top: i * altoHora,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.white.withValues(alpha: 0.15)),
          )),
          ..._obtenerWidgetsMaterias(dia),
        ],
      ),
    );
  }

  List<Widget> _obtenerWidgetsMaterias(String dia) {
    List<Widget> lista = [];
    for (var m in misMaterias) {
      for (var s in m.sesiones) {
        if (s.dia == dia) {
          double top = (s.horaInicio - horaInicioTabla) * altoHora;
          double height = (s.horaFin - s.horaInicio) * altoHora;

          lista.add(Positioned(
            top: top,
            left: 4,
            right: 4,
            height: height,
            child: GestureDetector(
              onTap: () => _mostrarDetalles(m),
              child: Container(
                decoration: BoxDecoration(
                  color: m.color.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(m.nombre, 
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), 
                        textAlign: TextAlign.center),
                    const SizedBox(height: 4),
                    Text(s.aula, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ));
        }
      }
    }
    return lista;
  }

  Widget _buildVistaDiariaSwipe() {
    return PageView.builder(
      controller: _pageController,
      itemCount: dias.length,
      itemBuilder: (context, index) {
        String dia = dias[index];
        List<Map<String, dynamic>> materiasDia = [];
        for (var m in misMaterias) {
          for (var s in m.sesiones) {
            if (s.dia == dia) materiasDia.add({'m': m, 's': s});
          }
        }
        materiasDia.sort((a, b) => a['s'].horaInicio.compareTo(b['s'].horaInicio));

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(dia, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFC8B3F6))),
            ),
            Expanded(
              child: materiasDia.isEmpty 
              ? const Center(child: Text("Sin clases este día"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: materiasDia.length,
                  itemBuilder: (context, i) {
                    final m = materiasDia[i]['m'] as Materia;
                    final s = materiasDia[i]['s'] as Sesion;
                    return Card(
                      color: m.color.withValues(alpha: 0.15),
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: m.color.withValues(alpha: 0.6)),
                      ),
                      child: ListTile(
                        title: Text(m.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${s.horaInicio.toInt()}:00 - ${s.horaFin.toInt()}:00\nSalón: ${s.aula}"),
                        onTap: () => _mostrarDetalles(m),
                      ),
                    );
                  },
                ),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDetalles(Materia m) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1B36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(m.nombre, style: TextStyle(color: m.color, fontWeight: FontWeight.bold)),
        content: SizedBox(
          // --- AQUÍ MODIFICAS EL TAMAÑO ---
          width: MediaQuery.of(context).size.width * 0.8, // 80% del ancho de la pantalla
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Docente: ${m.maestro}", style: const TextStyle(fontSize: 18)), // Texto más grande
              const SizedBox(height: 20),
              const Text("Horarios:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
              const SizedBox(height: 10),
              ...m.sesiones.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "• ${s.dia}: ${s.horaInicio.toInt()}:00 - ${s.horaFin.toInt()}:00 (${s.aula})",
                  style: const TextStyle(fontSize: 16),
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Cerrar", style: TextStyle(fontSize: 16))
          )
        ],
      ),
    );
  }
}