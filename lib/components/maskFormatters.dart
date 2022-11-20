import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FieldTextMask {
  static MaskTextInputFormatter get maskPhoneNumber {
    return MaskTextInputFormatter(
        mask: '(##) #####-####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }

  static MaskTextInputFormatter get maskCPF {
    return MaskTextInputFormatter(
        mask: '###.###.###-##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }

  static MaskTextInputFormatter get maskRG {
    return MaskTextInputFormatter(
        mask: '#########',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }

  static MaskTextInputFormatter get maskCEP {
    return MaskTextInputFormatter(
        mask: '#####-###',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }

  static MaskTextInputFormatter get maskDate {
    return MaskTextInputFormatter(
        mask: '##/##/####',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }

  static MaskTextInputFormatter get maskCNHRegisterNumb {
    return MaskTextInputFormatter(
        mask: '############',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }

  static MaskTextInputFormatter get maskCNHNumb {
    return MaskTextInputFormatter(
        mask: '##########',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }
}
