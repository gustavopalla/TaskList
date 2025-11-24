import 'package:flutter/material.dart';
import 'package:task_list/Model/Tarefa/tarefa.dart';
import 'package:task_list/Repository/TarefaRepository/tarefa_repository.dart';


typedef TarefaComChave = MapEntry<dynamic, Tarefa>; 

class TarefaProvider with ChangeNotifier {
  
  final TarefaRepository _repository = TarefaRepository();

  
  List<TarefaComChave> _allTarefasComChave = [];
  bool _isLoading = true;
  bool _apenasNaoConcluidas = false;
  
  bool get isLoading => _isLoading;
  bool get apenasNaoConcluidas => _apenasNaoConcluidas;

  int get naoConcluidasCount => _allTarefasComChave.where((e) => !e.value.getConcluido()).length;
  int get concluidasCount => _allTarefasComChave.where((e) => e.value.getConcluido()).length;

  List<TarefaComChave> get tarefasExibidas {
    if (_apenasNaoConcluidas) {
      return _allTarefasComChave.where((e) => !e.value.getConcluido()).toList();
    }
    return _allTarefasComChave;
  }

  TarefaProvider() {
    _initializeData();
  }


  Future<void> _initializeData() async {
    _isLoading = true;
    notifyListeners();

    await _repository.openBox(); 
    await _obterTarefas();
    
    _isLoading = false;
    notifyListeners(); 
  }

  Future<void> _obterTarefas() async {
    _allTarefasComChave = await _repository.listarTarefasComChave();
  }
  

  Future<void> adicionarTarefa(String descricao) async {
    final novaTarefa = Tarefa(descricao, false);
    await _repository.adicionarTarefa(novaTarefa);
    
    await _obterTarefas();
    notifyListeners(); 
  }

  void setFiltrarNaoConcluidas(bool value) {
    _apenasNaoConcluidas = value;
    notifyListeners();
  }

  Future<void> alternarConclusao(TarefaComChave tarefaComChave, bool newValue) async {
    final key = tarefaComChave.key;
    
    await _repository.alterarTarefa(key, newValue); 
    
    tarefaComChave.value.setConcluido(newValue);
    
    notifyListeners(); 
  }

  Future<void> removerTarefa(TarefaComChave tarefaComChave) async {
    final key = tarefaComChave.key;
    
    await _repository.removeTarefa(key);
    
    _allTarefasComChave.removeWhere((e) => e.key == key);
    
    notifyListeners(); 
  }
}