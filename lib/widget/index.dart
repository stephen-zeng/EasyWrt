import 'package:easywrt/widget/memory.dart';
import 'package:flutter/cupertino.dart';

final Map<String, StatefulWidget> widgetIndex = {
  "memoryInfo": MemoryInfoWidget(),
};

final Map<String, List<String> > widgetSegNeeds = {
  "memoryInfo": ["system", "info"],
};