import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_list/Model/Tarefa/tarefa.dart';
import 'package:task_list/Repository/TarefaRepository/tarefa_repository.dart';

typedef TarefaComChave = MapEntry<dynamic, Tarefa>;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  var descricaoController = TextEditingController();
  
  var _tarefasComChave = <TarefaComChave>[]; 
  
  TarefaRepository tarefaRepository = TarefaRepository();
  bool apenasNaoConcluidas = false;
  
  bool _isLoading = true; 

  int _concluidasCount = 0;
  int _naoConcluidasCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  
  _initializeData() async { 
    await tarefaRepository.openBox(); 
    await obterTarefas();
    setState(() {
      _isLoading = false;
    });
  }

  obterTarefas() async{

    final allTarefasComChave = await tarefaRepository.listarTarefasComChave();

    final allTarefas = allTarefasComChave.map((entry) => entry.value).toList();

    _naoConcluidasCount = allTarefas.where((t) => !t.getConcluido()).length;
    _concluidasCount = allTarefas.where((t) => t.getConcluido()).length;

    if(apenasNaoConcluidas){
      _tarefasComChave = allTarefasComChave
          .where((entry) => !entry.value.getConcluido())
          .toList();
    }
    else {
      _tarefasComChave = allTarefasComChave;
    }
    
    if(mounted && !_isLoading){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const FaIcon(FontAwesomeIcons.check),
          onPressed: _isLoading ? null : (){ 
            descricaoController.text = "";
            showDialog(
              context: context, 
              builder: (BuildContext bc){
                return AlertDialog(
                  title: const Text(
                    'Nova Tarefa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  content: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Digite o nome da tarefa'
                    ),
                    controller: descricaoController,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: const Text('Cancelar')
                    ),
                    TextButton(
                      onPressed: () async{
                        final novaDescricao = descricaoController.text.trim();
                        
                        if (novaDescricao.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("A descrição da tarefa não pode ser vazia!"))
                            );
                            return; 
                        }
                        
                        try {
                            await tarefaRepository.adicionarTarefa(Tarefa(novaDescricao, false));
                            
                            Navigator.of(context).pop();
                            setState(() {
                              obterTarefas();
                            });
                        } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Erro ao adicionar: $e"))
                            );
                        }
                      }, 
                      child: const Text('Adicionar')
                    ),
                  ],
                );
              },
            );
          }
        ),
        appBar: AppBar(title: const Text('Task List')),
        body: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filtrar apenas não concluídas',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Switch(
                      value: apenasNaoConcluidas, 
                      onChanged: (value){
                        setState(() {
                          apenasNaoConcluidas = value;
                          obterTarefas();
                        });
                      }
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(apenasNaoConcluidas
                      ? 'Total de tarefas não concluídas: $_naoConcluidasCount'
                      : 'Total de tarefas concluídas: $_concluidasCount',
                  style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),),
                ),
              ),
              Expanded(
                child: _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: _tarefasComChave.length,
                  itemBuilder: (BuildContext bc,int index) {
                    final tarefaComChave = _tarefasComChave[index];
                    final dynamic key = tarefaComChave.key;      
                    final Tarefa tarefa = tarefaComChave.value;  
                    
                    return Dismissible(
                      key: Key(key.toString()), 
                      onDismissed: (direction) async{
                        await tarefaRepository.removeTarefa(key); 
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Tarefa '${tarefa.getDescricao()}' removida"))
                        );
                        
                        setState(() {
                           _tarefasComChave.removeAt(index);
                           obterTarefas(); 
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Container(
                                child: ListTile(
                                  title: Text(tarefa.getDescricao()),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Switch(
                            value: tarefa.getConcluido(), 
                            onChanged: (bool value) async{
                              await tarefaRepository.alterarTarefa(key, value); 
                              setState(() {
                                obterTarefas();
                              });
                            }
                          ),
                          ),
                        ],
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