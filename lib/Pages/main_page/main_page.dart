import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_list/Model/Tarefa/tarefa.dart';
import 'package:task_list/Repository/TarefaRepository/tarefa_repository.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var descricaoController = TextEditingController();
  var _tarefas = <Tarefa>[];
  TarefaRepository tarefaRepository = TarefaRepository();
  bool apenasNaoConcluidas = false;

  @override
  void initState() {
    super.initState();
    obterTarefas();
  }

  void obterTarefas() async{
    if(apenasNaoConcluidas){
      _tarefas = await tarefaRepository.listarNaoConcluidas();
      setState(() {});
      return;
    }
    else {
      _tarefas = await tarefaRepository.listarTarefas();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: FaIcon(FontAwesomeIcons.check),
          onPressed: (){
            descricaoController.text = "";
            showDialog(
              context: context, 
              builder: (BuildContext bc){
                return AlertDialog(
                  title: Text(
                    'Nova Tarefa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  content: TextField(
                    decoration: InputDecoration(
                      hintText: 'Digite o nome da tarefa'
                    ),
                    controller: descricaoController,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: Text('Cancelar')
                    ),
                    TextButton(
                      onPressed: () async{
                        await tarefaRepository.adicionarTarefa(Tarefa(descricaoController.text, false));
                        Navigator.of(bc).pop;
                        setState(() {
                          obterTarefas();
                        });
                      }, 
                      child: Text('Adicionar')
                    ),
                  ],
                );
              },
            );
          }
        ),
        appBar: AppBar(title: Text('Task List')),
        body: Container(
          child: Column(
            children: [
              Container(
                child: Row(

                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _tarefas.length,
                  itemBuilder: (BuildContext bc,int index) {
                    var tarefa = _tarefas[index];
                    return Dismissible(
                      key: Key(tarefa.getId()), 
                      onDismissed: (direction) async{
                        await tarefaRepository.removeTarefa(tarefa.getId());
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Tarefa '${tarefa.getDescricao()}' removida"))
                      );
                      setState(() {
                        obterTarefas();
                      });
                      },
                      child: ListTile(
                        title: Text(tarefa.getDescricao()),
                      ),
                      );
                  },
                )
              ),
            ],
          ),
        ),
        
      )
    );
  }
}