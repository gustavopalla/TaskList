import 'package:flutter/material.dart';
import 'package:task_list/Model/Tarefa/tarefa.dart';
import 'package:task_list/Repository/TarefaRepository/tarefa_repository.dart';

// Use o mesmo typedef do seu Repositório para consistência
typedef TarefaComChave = MapEntry<dynamic, Tarefa>; 

class TarefaProvider with ChangeNotifier {
  
  final TarefaRepository _repository = TarefaRepository();

  // Variáveis de Estado (Membros privados)
  List<TarefaComChave> _allTarefasComChave = [];
  bool _isLoading = true;
  bool _apenasNaoConcluidas = false;

  // Getters para a UI
  bool get isLoading => _isLoading;
  bool get apenasNaoConcluidas => _apenasNaoConcluidas;

  int get naoConcluidasCount => _allTarefasComChave.where((e) => !e.value.getConcluido()).length;
  int get concluidasCount => _allTarefasComChave.where((e) => e.value.getConcluido()).length;

  // Getter que aplica o filtro antes de retornar a lista para a UI
  List<TarefaComChave> get tarefasExibidas {
    if (_apenasNaoConcluidas) {
      return _allTarefasComChave.where((e) => !e.value.getConcluido()).toList();
    }
    return _allTarefasComChave;
  }

  TarefaProvider() {
    _initializeData();
  }

  // --- LÓGICA DE CARREGAMENTO ---

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
  
  // --- LÓGICA DE NEGÓCIOS (MÉTODOS) ---

  Future<void> adicionarTarefa(String descricao) async {
    final novaTarefa = Tarefa(descricao, false);
    await _repository.adicionarTarefa(novaTarefa);
    
    await _obterTarefas(); // Recarrega a lista para obter a nova Key
    notifyListeners(); 
  }

  void setFiltrarNaoConcluidas(bool value) {
    _apenasNaoConcluidas = value;
    notifyListeners(); // A UI se reconstruirá usando o getter tarefasExibidas
  }

  Future<void> alternarConclusao(TarefaComChave tarefaComChave, bool newValue) async {
    final key = tarefaComChave.key;
    
    await _repository.alterarTarefa(key, newValue); 
    
    // Atualiza o objeto em memória para evitar um novo carregamento completo
    tarefaComChave.value.setConcluido(newValue);
    
    notifyListeners(); 
  }

  Future<void> removerTarefa(TarefaComChave tarefaComChave) async {
    final key = tarefaComChave.key;
    
    await _repository.removeTarefa(key);
    
    // Remove da lista em memória
    _allTarefasComChave.removeWhere((e) => e.key == key);
    
    notifyListeners(); 
  }
}