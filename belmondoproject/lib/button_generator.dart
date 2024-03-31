import 'package:riverpod/riverpod.dart';

// Isso aqui de alguma forma ajuda a guardar as mensagens infinitas dos botões

class ButtonGenerator extends Notifier<List<String>> {

  @override
  List<String> build() {
    return [];
  }

  void addString(String str) {
    state = [...state, str];
    print(state);
  }
}

var strNotifierProvider = NotifierProvider<ButtonGenerator, List<String>>(ButtonGenerator.new);