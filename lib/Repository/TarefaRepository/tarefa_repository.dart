import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/Model/Tarefa/tarefa.dart';

typedef TarefaComChave = MapEntry<dynamic, Tarefa>;

class TarefaRepository {
  
  static const String _boxName = 'tarefasBox';

  late Box<Tarefa> _tarefaBox;

  Future<void> openBox() async{
    if(!Hive.isAdapterRegistered(0)){
      Hive.registerAdapter(TarefaAdapter()); 
    }
    _tarefaBox = await Hive.openBox<Tarefa>(_boxName);
  }

  Future<void> adicionarTarefa(Tarefa tarefa) async{
    await _tarefaBox.add(tarefa);
  }
  Future<List<TarefaComChave>> listarTarefasComChave() async{
    final Map<dynamic, Tarefa> tarefasMap = _tarefaBox.toMap();
    return tarefasMap.entries.toList();
  }
  Future<void> alterarTarefa(dynamic key, bool concluido) async{
    final Tarefa? tarefa = _tarefaBox.get(key);
    
    if (tarefa != null) {
      tarefa.setConcluido(concluido); 
      await _tarefaBox.put(key, tarefa);
    }
  }

  Future<List<Tarefa>> listarTarefas() async{
    return _tarefaBox.values.toList();
  }
  
  Future<void> removeTarefa(dynamic key) async{
    await _tarefaBox.delete(key);
  }
}