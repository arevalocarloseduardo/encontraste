

import 'package:encontraste/utils/prefix.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Validators {
  static String validateTel(String val) {
    if (val.isEmpty) {
      return "El número no puede estar vacio";
    }
    return _validarT(val);
  }

  static String validateTelComercial(String val) {
    if (val.isEmpty) {
      return "El número no puede estar vacio";
    }
    return _validarT(val);
  }

  static String _validarT(String tel) {
    var parts = _convertToListAndClean(tel);
    if (parts[0] == "0" && parts.length != 1 && parts[1] != "0") {
      parts.removeAt(0);
      var meetPreffix4 = _foundPrefix(parts.take(4).toList());
      var meetPreffix3 = _foundPrefix(parts.take(3).toList());
      var meetPreffix2 = _foundPrefix(parts.take(2).toList());
      if (parts.length != 10) {
        return "Ingresar teléfono completo con código de área";
      }
      if (meetPreffix4.length == 1) {
        return null;
      }
      if (meetPreffix3.length == 1) {
        return null;
      }
      if (meetPreffix2.length == 1) {
        return null;
      } else {
        return "Prefijo no encontrado";
      }
    } else {
      if (parts.length != 10) {
        return "Ingresar teléfono completo con código de área";
      }
      var meetPreffix4 = _foundPrefix(parts.take(4).toList());
      var meetPreffix3 = _foundPrefix(parts.take(3).toList());
      var meetPreffix2 = _foundPrefix(parts.take(2).toList());
      if (meetPreffix4.length == 1) {
        return null;
      }
      if (meetPreffix3.length == 1) {
        return null;
      }
      if (meetPreffix2.length == 1) {
        return null;
      } else {
        return "Prefijo no encontrado";
      }
    }
  }

  static List<String> _convertToListAndClean(String tel) {
    var temp = tel.split("");
    var parts = List<String>.from(temp);
    parts.remove("(");
    parts.remove(")");
    parts.remove("-");
    return parts;
  }

  static List<String> _foundPrefix(List<String> parts) {
    var lista = PrefixTel.prefix;
    var found =
        lista.where((prefix) => prefix.startsWith(parts.join())).toList();
    return found;
  }

 static String validarCodigo(String tel, MaskedTextController controller) {
    
    var parts = _convertToListAndClean(tel);
    if (parts[0] == "0" && parts.length != 1) {
      parts.removeAt(0);
      print("ingreso: $parts");
      print("large: ${parts.length}");
      if (parts.length > 2) {
        var meetPreffix = _foundPrefix(parts.take(2).toList());
        if (meetPreffix.length == 1) {
          controller.updateMask('000-00000000');
          print("${meetPreffix.join()} ${parts.skip(2).toList().join()}");
        }
      }
      if (parts.length > 2) {
        var meetPreffix = _foundPrefix(parts.take(3).toList());
        if (meetPreffix.length == 1) {
          controller.updateMask('0000-0000000');
          print("${meetPreffix.join()} ${parts.skip(3).toList().join()}");
        }
      }
      if (parts.length > 3) {
        var meetPreffix = _foundPrefix(parts.take(4).toList());
        if (meetPreffix.length == 1) {
          controller.updateMask('00000-000000');
          print("${meetPreffix.join()} ${parts.skip(4).toList().join()}");
        }
      }
    } else {
      print("ingreso: $parts");
      print("large: ${parts.length}");
      if (parts.length > 2) {
        var meetPreffix = _foundPrefix(parts.take(2).toList());
        if (meetPreffix.length == 1) {
          controller.updateMask('00-00000000');
          print("${meetPreffix.join()} ${parts.skip(2).toList().join()}");
        }
      }
      if (parts.length > 2) {
        var meetPreffix = _foundPrefix(parts.take(3).toList());
        if (meetPreffix.length == 1) {
          controller.updateMask('000-0000000');
          print("${meetPreffix.join()} ${parts.skip(3).toList().join()}");
        }
      }
      if (parts.length > 3) {
        var meetPreffix = _foundPrefix(parts.take(4).toList());
        if (meetPreffix.length == 1) {
          controller.updateMask('0000-000000');
          print("${meetPreffix.join()} ${parts.skip(4).toList().join()}");
        }
      }
    }
    return validateTel(tel);
  } 
  static String emailValidator(String anEmailAddress) {
    if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(anEmailAddress)) {
      return null;
    } else {
      return "Email Inválido";
    }
  }

  static String cbuNotEmptyOrNullValidator(String toValidate) {
    print(toValidate);
    if (toValidate == null || toValidate == '') {
      return "El CBU no puede estar vacio";
    }

    return validateCBU(toValidate);
  }

  static bool _validateLengthCBU(String cbu) {
    if (cbu.length != 22) {
      return false;
    }
    return true;
  }

  static bool _validateBlock1(String bloque1) {
    print(bloque1);
    if (bloque1.length != 8) {
      return false;
    }
    var banco = bloque1.substring(0, 3);
    var digitoVerificador1 = int.parse(bloque1[3]);
    var sucursal = bloque1.substring(4, 7); //check 4,3 or 4,7
    var digitoVerificador2 = int.parse(bloque1[7]);
    var suma = int.parse(banco[0]) * 7 +
        int.parse(banco[1]) * 1 +
        int.parse(banco[2]) * 3 +
        digitoVerificador1 * 9 +
        int.parse(sucursal[0]) * 7 +
        int.parse(sucursal[1]) * 1 +
        int.parse(sucursal[2]) * 3;
    var diferencia = (10 - (suma % 10)) % 10;
    return diferencia == digitoVerificador2;
  }

  static bool _validateBlock2(String block2) {
    print(block2);
    if (block2.length != 14) {
      return false;
    }
    var digitoVerificador = int.parse(block2[13]);
    var suma = int.parse(block2[0]) * 3 +
        int.parse(block2[1]) * 9 +
        int.parse(block2[2]) * 7 +
        int.parse(block2[3]) * 1 +
        int.parse(block2[4]) * 3 +
        int.parse(block2[5]) * 9 +
        int.parse(block2[6]) * 7 +
        int.parse(block2[7]) * 1 +
        int.parse(block2[8]) * 3 +
        int.parse(block2[9]) * 9 +
        int.parse(block2[10]) * 7 +
        int.parse(block2[11]) * 1 +
        int.parse(block2[12]) * 3;
    var diferencia = (10 - (suma % 10)) % 10;
    return diferencia == digitoVerificador;
  }

  static String validateCBU(String cbuTemp) { 
    String cbu="";
    var temp = cbuTemp.split("");
    var parts = List<String>.from(temp);
    for (var i = 0; i < 5; i++) {
       parts.remove("-");
    }   
    cbu=parts.join();  

    var value = _validateLengthCBU(cbu) &&
        _validateBlock2(cbu.substring(8, 22)) &&
        _validateBlock1(cbu.substring(0, 8));

    if (cbu.length < 22 && cbu.length > 0) {
      return "Completá el CBU con 22 dígitos";
    } 
    if (cbuTemp == "") {
      return "El CBU no puede estar vacio";
    }
    if (value) {
      return null;
    } else if (!_validateLengthCBU(cbu)) {
      return null;
    } else {
      return "El CBU es incorrecto";
    }
  }
}
