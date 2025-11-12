import 'package:flutter/material.dart';
import 'dart:math';

class ChatAIScreen extends StatefulWidget {
  @override
  State<ChatAIScreen> createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _mensajes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarMensajesIniciales();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _cargarMensajesIniciales() {
    _mensajes = [
      {
        'id': '1',
        'texto': '¡Hola! Soy el asistente de SmartSales365. ¿En qué puedo ayudarte?',
        'esUsuario': false,
        'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
      },
    ];
    setState(() {});
  }

  Future<void> _enviarMensaje() async {
    if (_messageController.text.trim().isEmpty) return;

    final mensaje = _messageController.text.trim();
    _messageController.clear();

    // Agregar mensaje del usuario
    setState(() {
      _mensajes.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'texto': mensaje,
        'esUsuario': true,
        'timestamp': DateTime.now(),
      });
      _isLoading = true;
    });

    // Scroll al final
    await Future.delayed(Duration(milliseconds: 100));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Simular respuesta de IA
    await Future.delayed(Duration(seconds: 2));

    final respuestas = _generarRespuesta(mensaje);

    setState(() {
      _mensajes.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'texto': respuestas,
        'esUsuario': false,
        'timestamp': DateTime.now(),
      });
      _isLoading = false;
    });

    // Scroll al final
    await Future.delayed(Duration(milliseconds: 100));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String _generarRespuesta(String mensaje) {
    final lower = mensaje.toLowerCase();

    if (lower.contains('hola') || lower.contains('halo')) {
      return '¡Hola! Bienvenido a SmartSales365. ¿Cómo puedo ayudarte hoy?';
    } else if (lower.contains('productos')) {
      return 'Tenemos una amplia variedad de productos disponibles. ¿Te gustaría buscar alguno en específico?';
    } else if (lower.contains('pedido') || lower.contains('compra')) {
      return 'Puedo ayudarte con tu pedido. ¿Deseas saber el estado, hacer un nuevo pedido o consultar algo más?';
    } else if (lower.contains('precio') || lower.contains('costo')) {
      return 'Los precios varían según el producto. Te recomiendo explorar el catálogo para más detalles. ¿Hay algo específico que busques?';
    } else if (lower.contains('envío') || lower.contains('entrega')) {
      return 'El envío generalmente toma 2-5 días hábiles según tu ubicación. ¿Necesitas rastrear un pedido?';
    } else if (lower.contains('problema') ||
        lower.contains('error') ||
        lower.contains('ayuda')) {
      return 'Lamento escuchar que tengas un problema. ¿Puedes describe qué está pasando para que pueda ayudarte mejor?';
    } else if (lower.contains('gracias')) {
      return '¡De nada! Estoy siempre disponible si necesitas más ayuda. ¿Hay algo más?';
    } else if (lower.contains('adios') || lower.contains('chao')) {
      return '¡Hasta luego! Gracias por usar SmartSales365. Vuelve pronto. 👋';
    } else {
      return 'Interesante pregunta. Aunque soy una IA de demostración, he entendido tu mensaje. ¿Puedo ayudarte con algo específico sobre SmartSales365?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistente IA'),
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Mensajes
          Expanded(
            child: _mensajes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Inicia una conversación',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount: _mensajes.length +
                        (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _mensajes.length) {
                        // Indicador de carga
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: _TypingIndicator(),
                          ),
                        );
                      }

                      final mensaje = _mensajes[index];
                      final esUsuario = mensaje['esUsuario'];

                      return Align(
                        alignment: esUsuario
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: esUsuario
                                ? Colors.blue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Column(
                            crossAxisAlignment: esUsuario
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                mensaje['texto'],
                                style: TextStyle(
                                  color: esUsuario
                                      ? Colors.white
                                      : Colors.black87,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _formatearTiempo(mensaje['timestamp']),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: esUsuario
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 3,
                    onSubmitted: (_) => _enviarMensaje(),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isLoading ? null : _enviarMensaje,
                  mini: true,
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatearTiempo(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inMinutes < 1) {
      return 'Ahora';
    } else if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes}m';
    } else if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours}h';
    } else {
      return '${fecha.day}/${fecha.month}';
    }
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final offset = sin((_controller.value + i * 0.1) * pi) * 4;
              return Transform.translate(
                offset: Offset(0, offset),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
