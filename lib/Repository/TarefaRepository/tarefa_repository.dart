import 'package:task_list/Model/Tarefa/tarefa.dart';

class TarefaRepository {
  final List<Tarefa> _tarefas = [];

  Future<void> adicionarTarefa(Tarefa tarefa) async{
    await Future.delayed(Duration(milliseconds: 200));
    _tarefas.add(tarefa);
  }

  Future<void> alterarTarefa(String id, bool concluido) async{
    await Future.delayed(Duration(milliseconds: 0));
    _tarefas.where((tarefa) => tarefa.getId() == id).first.setConcluido(concluido);
  }

  Future<List<Tarefa>> listarTarefas() async{
    await Future.delayed(Duration(milliseconds: 100));

    return _tarefas;

  }

  Future<List<Tarefa>> listarNaoConcluidas() async{
    await Future.delayed(Duration(milliseconds: 100));

    return _tarefas.where((tarefa) => !tarefa.getConcluido()).toList();
  }

  Future<void> removeTarefa(String id) async{
    await Future.delayed(Duration(milliseconds: 100));
    return _tarefas.removeWhere((tarefa) => tarefa.getId() == id);
  }


}