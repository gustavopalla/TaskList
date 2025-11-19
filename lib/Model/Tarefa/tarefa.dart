import 'package:hive/hive.dart';
part 'tarefa.g.dart'; 

@HiveType(typeId: 0)
class Tarefa {

  
  @HiveField(0) 
  String _descricao = "";
  @HiveField(1) 
  bool _concluido = false;

  Tarefa(this._descricao, this._concluido);


  String getDescricao (){
    return _descricao;
  }

  void setDescricao(String descricao){
    _descricao = descricao;
  }

  bool getConcluido(){
    return _concluido;
  }

  void setConcluido(bool concluido){
    _concluido = concluido;
  }
}