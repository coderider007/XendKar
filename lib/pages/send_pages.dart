import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xendkar/constants.dart';

class SendPage extends StatefulWidget {
  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Select File Picker example app'),
          bottom: TabBar(
            isScrollable: true,
            tabs: choices.map((Choice choice) {
              return Tab(
                text: choice.title,
                icon: Icon(choice.icon),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: choices.map((Choice choice) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ChoiceCard(choice: choice),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Recent', icon: Icons.watch_later),
  const Choice(title: 'Files', icon: Icons.folder),
  const Choice(title: 'Videos', icon: Icons.video_library),
  const Choice(title: 'Pictures', icon: Icons.photo_library),
  const Choice(title: 'Apps', icon: Icons.android),
  const Choice(title: 'Audio', icon: Icons.library_music),
];

class ChoiceCard extends StatefulWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  _ChoiceCardState createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard> {
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      if (_multiPick) {
        _path = null;
        _paths = await FilePicker.getMultiFilePath(
          type: _pickingType,
          allowedExtensions: (_extension?.isNotEmpty ?? false)
              ? _extension?.replaceAll(' ', '')?.split(',')
              : null,
        );
      } else {
        _paths = null;
        _path = await FilePicker.getFilePath(
          type: _pickingType,
          allowedExtensions: (_extension?.isNotEmpty ?? false)
              ? _extension?.replaceAll(' ', '')?.split(',')
              : null,
        );
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }

  void _selectFolder() {
    FilePicker.getDirectoryPath().then((value) {
      setState(() => _path = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return this.widget.choice.title == 'CAR'
        ? Center(
            child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: DropdownButton(
                        hint: Text('LOAD PATH FROM'),
                        value: _pickingType,
                        items: <DropdownMenuItem>[
                          DropdownMenuItem(
                            child: Text('FROM AUDIO'),
                            value: FileType.audio,
                          ),
                          DropdownMenuItem(
                            child: Text('FROM IMAGE'),
                            value: FileType.image,
                          ),
                          DropdownMenuItem(
                            child: Text('FROM VIDEO'),
                            value: FileType.video,
                          ),
                          DropdownMenuItem(
                            child: Text('FROM MEDIA'),
                            value: FileType.media,
                          ),
                          DropdownMenuItem(
                            child: Text('FROM ANY'),
                            value: FileType.any,
                          ),
                          DropdownMenuItem(
                            child: Text('CUSTOM FORMAT'),
                            value: FileType.custom,
                          ),
                        ],
                        onChanged: (value) => setState(() {
                              _pickingType = value;
                              if (_pickingType != FileType.custom) {
                                _controller.text = _extension = '';
                              }
                            })),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 100.0),
                    child: _pickingType == FileType.custom
                        ? TextFormField(
                            maxLength: 15,
                            autovalidate: true,
                            controller: _controller,
                            decoration:
                                InputDecoration(labelText: 'File extension'),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.none,
                          )
                        : Container(),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 200.0),
                    child: SwitchListTile.adaptive(
                      title: Text('Pick multiple files',
                          textAlign: TextAlign.right),
                      onChanged: (bool value) =>
                          setState(() => _multiPick = value),
                      value: _multiPick,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () => _openFileExplorer(),
                          child: Text("Open file picker"),
                        ),
                        RaisedButton(
                          onPressed: () => _selectFolder(),
                          child: Text("Pick folder"),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) => _loadingPath
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: const CircularProgressIndicator())
                        : _path != null || _paths != null
                            ? Container(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.50,
                                child: Scrollbar(
                                    child: ListView.separated(
                                  itemCount: _paths != null && _paths.isNotEmpty
                                      ? _paths.length
                                      : 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final bool isMultiPath =
                                        _paths != null && _paths.isNotEmpty;
                                    final String name = 'File $index: ' +
                                        (isMultiPath
                                            ? _paths.keys.toList()[index]
                                            : _fileName ?? '...');
                                    final path = isMultiPath
                                        ? _paths.values
                                            .toList()[index]
                                            .toString()
                                        : _path;

                                    return ListTile(
                                      title: Text(
                                        name,
                                      ),
                                      subtitle: Text(path),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Divider(),
                                )),
                              )
                            : Container(),
                  ),
                ],
              ),
            ),
          ))
        : Card(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(widget.choice.icon, size: 128.0, color: textStyle.color),
                  Text(widget.choice.title, style: textStyle),
                ],
              ),
            ),
          );
  }
}
