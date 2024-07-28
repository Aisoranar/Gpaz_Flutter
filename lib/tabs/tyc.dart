import 'package:flutter/material.dart';

class TermsAndConditionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(247, 0, 51, 122),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'TÉRMINOS Y CONDICIONES',
                      style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 48), // Espacio para centrar el título
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('1. Introducción'),
                    _buildSectionContent(
                      'Bienvenido a GPaz, una aplicación móvil diseñada para ayudar a los estudiantes y personal de UNIPAZ a gestionar el transporte público, proporcionando información en tiempo real sobre la ubicación de los autobuses, dónde esperarlos, y detalles sobre rutas y horarios. Al utilizar GPaz, usted acepta cumplir y estar sujeto a los siguientes Términos y Condiciones.',
                    ),
                    _buildSectionTitle('2. Aceptación de los Términos'),
                    _buildSectionContent(
                      'Al descargar, instalar y utilizar la aplicación GPaz, usted acepta estos Términos y Condiciones en su totalidad. Si no está de acuerdo con estos términos, no utilice la aplicación.',
                    ),
                    _buildSectionTitle('3. Descripción del Servicio'),
                    _buildSectionContent(
                      'GPaz proporciona a los usuarios la ubicación en tiempo real de los autobuses, información sobre rutas, horarios y puntos de espera. La aplicación está disponible para estudiantes, personal y cualquier usuario que pertenezca a UNIPAZ. Los conductores deben ser verificados antes de su registro en la aplicación.',
                    ),
                    _buildSectionTitle('4. Uso de Datos Personales'),
                    _buildSectionContent(
                      '4.1 Estudiantes y Personal de UNIPAZ: No es necesario registrarse para usar la aplicación, lo que protege su privacidad. No recopilamos ni almacenamos datos personales identificables de los usuarios.\n\n'
                      '4.2 Conductores: Los conductores deben ser verificados y registrados en la aplicación. Los datos personales de los conductores son cifrados y protegidos según los estándares de seguridad de Google.',
                    ),
                    _buildSectionTitle('5. Uso del GPS'),
                    _buildSectionContent(
                      'Para proporcionar información precisa sobre la ubicación de los autobuses en tiempo real, GPaz requiere acceso a los servicios de ubicación de su dispositivo. Al usar GPaz, usted acepta que la aplicación recoja, utilice y comparta datos de ubicación con el propósito de mejorar el servicio.',
                    ),
                    _buildSectionTitle('6. Responsabilidades del Usuario'),
                    _buildSectionContent(
                      '6.1 Uso Adecuado: Los usuarios deben utilizar la aplicación de manera adecuada y conforme a las leyes y regulaciones aplicables. Cualquier uso indebido de la aplicación, incluido pero no limitado a la manipulación de datos de ubicación o el uso de la aplicación para fines ilícitos, está estrictamente prohibido.\n\n'
                      '6.2 Dispositivos Compatibles: Los usuarios son responsables de asegurarse de que su dispositivo sea compatible con la aplicación GPaz y de mantener la seguridad de su dispositivo.',
                    ),
                    _buildSectionTitle('7. Limitaciones de Responsabilidad'),
                    _buildSectionContent(
                      '7.1 Precisión de la Información: Aunque GPaz se esfuerza por proporcionar información precisa y actualizada sobre la ubicación de los autobuses, no garantizamos la exactitud, integridad o actualidad de dicha información.\n\n'
                      '7.2 Interrupciones del Servicio: GPaz no será responsable por interrupciones, retrasos o errores en el servicio debido a causas fuera de nuestro control, incluyendo, pero no limitándose a, problemas técnicos, fallos de red o actos de terceros.',
                    ),
                    _buildSectionTitle('8. Propiedad Intelectual'),
                    _buildSectionContent(
                      'Todos los derechos, títulos e intereses en y para la aplicación GPaz, incluyendo pero no limitándose a derechos de autor, patentes, marcas registradas y secretos comerciales, son propiedad de GPaz o sus licenciantes. Usted no adquiere ningún derecho o licencia sobre la aplicación, salvo lo expresamente otorgado en estos Términos y Condiciones.',
                    ),
                    _buildSectionTitle('9. Modificaciones a los Términos y Condiciones'),
                    _buildSectionContent(
                      'Nos reservamos el derecho de modificar estos Términos y Condiciones en cualquier momento. Las modificaciones serán efectivas al ser publicadas en nuestra página web o notificadas a través de la aplicación. El uso continuado de GPaz después de cualquier modificación constituye su aceptación de los nuevos términos.',
                    ),
                    _buildSectionTitle('10. Terminación del Servicio'),
                    _buildSectionContent(
                      'Nos reservamos el derecho de suspender o terminar su acceso a la aplicación GPaz en cualquier momento, sin previo aviso, por cualquier razón, incluyendo pero no limitado a, el incumplimiento de estos Términos y Condiciones.',
                    ),
                    _buildSectionTitle('11. Ley Aplicable y Jurisdicción'),
                    _buildSectionContent(
                      'Estos Términos y Condiciones se regirán e interpretarán de acuerdo con las leyes vigentes en Barrancabermeja, Santander, Colombia. Cualquier disputa que surja en relación con estos Términos y Condiciones será resuelta exclusivamente en los tribunales de Barrancabermeja, Santander, Colombia.',
                    ),
                    _buildSectionTitle('12. Contacto'),
                    _buildSectionContent(
                      'Si tiene alguna pregunta o inquietud sobre estos Términos y Condiciones, por favor contáctenos a través de gpazunipaz@gmail.com.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color.fromARGB(247, 0, 51, 122)),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }
}
