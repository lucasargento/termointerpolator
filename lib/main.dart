import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Termo Interpolator',
      theme: ThemeData(
        primarySwatch: Colors.red,
        backgroundColor: Colors.redAccent,
      ),
      home: MyHomePage(title: 'Termo Interpolator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double ancho;
  double alto;
  TextEditingController dato_controller = TextEditingController();
  TextEditingController x1_controller = TextEditingController();
  TextEditingController x2_controller = TextEditingController();
  TextEditingController y1_controller = TextEditingController();
  TextEditingController y2_controller = TextEditingController();

  String resultado = "I - Resultado de la interpolación";

  void interpolate() {
    /*
        Caso de uso:
            queremos obtener la temperatura de un estado termodinamico. Tenemos el dato de la Presion = 155kpa. vamos a la tabla y solo tenemos 150 y 160 kpa. Lo que tenemos que 
            hacer para obtener la temperatura a 155kpa es interpolar entre 150 y 160 con sus respectivas temperaturas. Pero es una cuenta paja que ademas da lugar a error. Sale s python
        Parametros
            dato = propiedad termodinamica dato del estado que tenemos. por ejemplo la presion.
            x1 = misma propiedad termodinamica que dato pero el valor 'minimo' (extremo inferior de la interpolacion) de la tabla
            x2 = misma propiedad termodinamica que dato pero valor 'maximo' (extremo superior de la interpolacion) de la tabla
            y1 = misma propiedad que el VALOR que queremos obtener pero del extremo 'minimo' (por ej si quiero obtener la temperatura, sera la temperatura del minimo extremo)
            y2 = misma propiedad que el VALOR que queremos obtener pero del extremo 'maximo' (por ej si quiero obtener la temperatura, sera la temperatura del maximo extremo)
        Return
            VALOR = valor numerico de lo que buscabamos obtener. 
        */
    try {
      double dato = double.parse(dato_controller.text);
      double x1 = double.parse(x1_controller.text);
      double x2 = double.parse(x2_controller.text);
      double y1 = double.parse(y1_controller.text);
      double y2 = double.parse(y2_controller.text);

      setState(() {
        double valor = ((dato - x1) / (x2 - x1)) * (y2 - y1) + y1;
        resultado = "I = " + valor.toString();
      });
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Los datos ingresados deben ser números, todos los datos son necesarios.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void clear() {
    setState(() {
      dato_controller.text = "";
      x1_controller.text = "";
      x2_controller.text = "";
      y1_controller.text = "";
      y2_controller.text = "";
      resultado = "I - Resultado de la interpolación";
    });
  }

  @override
  Widget build(BuildContext context) {
    alto = MediaQuery.of(context).size.height;
    ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white10,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset('assets/interpol.png'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputButton(
                    alto: alto,
                    ancho: ancho,
                    dato_controller: dato_controller,
                    hint: "X - Dato que tenés para interpolar",
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputButton(
                    alto: alto,
                    ancho: ancho,
                    dato_controller: x1_controller,
                    hint: "X1 - Misma propiedad que el dato, extremo inferior",
                  ),
                  InputButton(
                    alto: alto,
                    ancho: ancho,
                    dato_controller: x2_controller,
                    hint: "X2 - Misma propiedad que el dato, extremo superior",
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputButton(
                    alto: alto,
                    ancho: ancho,
                    dato_controller: y1_controller,
                    hint:
                        "Y1 - Misma propiedad que la propidead termodinamica que se desea obtener, extremo inferior",
                  ),
                  InputButton(
                    alto: alto,
                    ancho: ancho,
                    dato_controller: y2_controller,
                    hint:
                        "Y2 - Misma propiedad que la propidead termodinamica que se desea obtener, extremo superior",
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: alto * 0.07,
                  width: ancho * 0.2,
                  constraints: BoxConstraints(minWidth: 210, minHeight: 50),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      resultado,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              ActionButton(
                  alto: alto, ancho: ancho, fun: interpolate, text: "Calcular"),
              ActionButton(
                  alto: alto, ancho: ancho, fun: clear, text: "Borrar todo"),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    @required this.alto,
    @required this.ancho,
    @required this.fun,
    @required this.text,
  }) : super(key: key);

  final double alto;
  final double ancho;
  final Function fun;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        child: Container(
          height: alto * 0.07,
          width: ancho * 0.2,
          constraints: BoxConstraints(minWidth: 200, minHeight: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: RawMaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onPressed: fun,
            child: Text(
              text,
              style: TextStyle(
                color: text == "Calcular" ? Colors.red : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InputButton extends StatelessWidget {
  const InputButton(
      {Key key,
      @required this.alto,
      @required this.ancho,
      @required this.dato_controller,
      @required this.hint})
      : super(key: key);

  final double alto;
  final double ancho;
  final TextEditingController dato_controller;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: alto * 0.07,
        width: ancho * 0.2,
        constraints: BoxConstraints(minWidth: 120, minHeight: 50),
        child: Tooltip(
          message: hint,
          child: TextField(
            textAlign: TextAlign.center,
            controller: dato_controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
}
