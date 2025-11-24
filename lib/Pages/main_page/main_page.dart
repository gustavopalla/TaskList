import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_list/Classes/tarefa_provider.dart';
import 'package:task_list/Model/Tarefa/tarefa.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return Consumer<TarefaProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              
              onPressed: provider.isLoading ? null : () => _mostrarDialogoAdicionarTarefa(context, provider), 
              child: const FaIcon(FontAwesomeIcons.check),
            ),
            appBar: AppBar(title: const Text('Task List')),
            body: Column(
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
                        value: provider.apenasNaoConcluidas, 
                        onChanged: (value){
                          
                          provider.setFiltrarNaoConcluidas(value); 
                        }
                      )
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    
                    child: Text(provider.apenasNaoConcluidas
                        ? 'Total de tarefas não concluídas: ${provider.naoConcluidasCount}'
                        : 'Total de tarefas concluídas: ${provider.concluidasCount}',
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),),
                  ),
                ),
                Expanded(
                  child: provider.isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: provider.tarefasExibidas.length,
                    itemBuilder: (BuildContext bc,int index) {
                      final tarefaComChave = provider.tarefasExibidas[index];
                      final dynamic key = tarefaComChave.key;      
                      final Tarefa tarefa = tarefaComChave.value;  
                      
                      return Dismissible(
                        key: Key(key.toString()), 
                        onDismissed: (direction) {
                          provider.removerTarefa(tarefaComChave); 
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Tarefa '${tarefa.getDescricao()}' removida"))
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: ListTile(
                                  title: Text(tarefa.getDescricao()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Switch(
                                value: tarefa.getConcluido(), 
                                onChanged: (bool value) {
                                  
                                  provider.alternarConclusao(tarefaComChave, value);
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
          )
        );
      },
    );
  }
  
  void _mostrarDialogoAdicionarTarefa(BuildContext context, TarefaProvider provider) {
    final descricaoController = TextEditingController();
    
    showDialog(
      context: context, 
      builder: (BuildContext dialogContext){
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
              onPressed: () => Navigator.pop(dialogContext), 
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
                  
                    await provider.adicionarTarefa(novaDescricao);
                    
                    Navigator.of(context).pop();
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
}