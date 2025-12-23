import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easywrt/beam/responsive_layout.dart';
import 'package:easywrt/beam/stripe_widget.dart';
import 'package:easywrt/db/models/hierarchy_items.dart';
import 'package:easywrt/modules/router/controllers/current_page_controller.dart';
import 'package:easywrt/modules/router/controllers/edit_controller.dart';
import 'package:easywrt/modules/router/widgets/add_widget_dialog.dart';

class RouterPageView extends ConsumerStatefulWidget {

  final String pageId;



  const RouterPageView({super.key, required this.pageId});



  @override

  ConsumerState<RouterPageView> createState() => _RouterPageViewState();

}



class _RouterPageViewState extends ConsumerState<RouterPageView> with WidgetsBindingObserver {

  Orientation? _lastOrientation;



  @override

  void initState() {

    super.initState();

    WidgetsBinding.instance.addObserver(this);

  }



  @override

  void dispose() {

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();

  }



  @override

  void didChangeMetrics() {

    // Check orientation change

    final orientation = MediaQuery.of(context).orientation;

    if (_lastOrientation != null && _lastOrientation != orientation) {

       // Orientation changed

       final editState = ref.read(editManagerProvider);

       if (editState.isEditing && editState.editingPageId == widget.pageId) {

           // Auto-save and exit

           ref.read(editManagerProvider.notifier).save();

       }

    }

    _lastOrientation = orientation;

  }



  @override

  Widget build(BuildContext context) {

    _lastOrientation ??= MediaQuery.of(context).orientation;

    final pageId = widget.pageId;



    final isLandscape = ResponsiveLayout.isLandscape(context);

    final editState = ref.watch(editManagerProvider);

    final isEditing = editState.isEditing && editState.editingPageId == pageId;

    final editController = ref.read(editManagerProvider.notifier);



    return ValueListenableBuilder(

      valueListenable: Hive.box<PageItem>('pages').listenable(),

      builder: (context, Box<PageItem> box, _) {

        // Use working copy if editing, otherwise hive data

        PageItem? page = box.get(pageId);

        if (isEditing && editState.workingPage != null) {

          page = editState.workingPage;

        }



        if (page == null) {

          return const Center(child: Text('Page not found'));

        }



        // Init/Sync CurrentPage (Legacy support if needed)

        // ref.read(currentPageProvider.notifier).init(page);



        return Scaffold(

          appBar: AppBar(

            automaticallyImplyLeading: !isLandscape && !isEditing,

            leading: _buildLeading(context, isLandscape, isEditing, editController),

            title: Text(page.name),

            actions: _buildActions(context, page, isEditing, editController),

          ),

          body: LayoutBuilder(

            builder: (context, constraints) {

              final stripes = page!.stripes ?? [];

              // Responsive Logic for Stripes wrapping could go here or in a wrapper widget

              // For now, simple ListView of stripes

              

              // Ensure minimum width compliance? 

              // FR-001.2: 19rem min width. If constraints.maxWidth < 19rem, we scroll horizontally.

              final minWidth = ResponsiveLayout.minStripeWidthPx;

              final shouldScrollHorizontal = constraints.maxWidth < minWidth;



              Widget content = ListView.builder(

                padding: const EdgeInsets.all(16),

                itemCount: stripes.length + (isEditing ? 1 : 0),

                itemBuilder: (context, index) {

                   if (isEditing && index == stripes.length) {

                     // Extra empty stripe at the bottom for adding new stripes

                     return _buildEmptyStripePlaceholder(context, constraints.maxWidth);

                   }

                   return Padding(

                     padding: const EdgeInsets.only(bottom: 16),

                     child: StripeWidget(

                       stripe: stripes[index], 

                       isEditing: isEditing,

                       width: shouldScrollHorizontal ? minWidth : constraints.maxWidth - 32, // -32 for padding

                     ),

                   );

                },

              );



              if (shouldScrollHorizontal) {

                content = SingleChildScrollView(

                  scrollDirection: Axis.horizontal,

                  child: SizedBox(

                    width: minWidth,

                    child: content,

                  ),

                );

              }



              return content;

            },

          ),

          floatingActionButton: isEditing

              ? FloatingActionButton(

                  onPressed: () {

                    showModalBottomSheet(

                      context: context,

                      builder: (_) => AddWidgetDialog(

                        onAdd: (widgetKey) {

                           ref.read(editManagerProvider.notifier).addWidget(widgetKey);

                        },

                      ),

                    );

                  },

                  child: const Icon(Icons.add),

                )

              : null,

        );

      },

    );

  }



  Widget? _buildLeading(BuildContext context, bool isLandscape, bool isEditing, EditController controller) {

    if (isEditing) {

      return IconButton(

        icon: const Icon(Icons.close),

        onPressed: () {

          // Confirm discard?

          controller.discard();

        },

      );

    }

    if (!isLandscape) {

      return IconButton(

        icon: const Icon(Icons.arrow_back),

        onPressed: () {

          final state = GoRouterState.of(context);

          final currentMid = state.uri.queryParameters['mid'] ?? 'router_root';

          context.go(Uri(

            path: '/router',

            queryParameters: {

              'mid': currentMid,

              'animateType': 'fromLeft',

            },

          ).toString());

        },

      );

    }

    return null;

  }



  List<Widget> _buildActions(BuildContext context, PageItem page, bool isEditing, EditController controller) {

    if (isEditing) {

      return [

        IconButton(

          icon: const Icon(Icons.check),

          onPressed: () {

            controller.save();

          },

        ),

      ];

    } else {

      // Menu

      return [

        PopupMenuButton<String>(

          onSelected: (value) {

            if (value == 'edit') {

              controller.enterEditMode(page);

            }

          },

          itemBuilder: (context) => [

            const PopupMenuItem(

              value: 'edit',

              child: Text('Edit Page'),

            ),

          ],

        ),

      ];

    }

  }



  Widget _buildEmptyStripePlaceholder(BuildContext context, double width) {

    return Container(

      height: 100,

      width: width,

            decoration: BoxDecoration(

              border: Border.all(color: Colors.grey.withOpacity(0.5), style: BorderStyle.solid),

              borderRadius: BorderRadius.circular(8),

            ),

      

      child: const Center(

        child: Text('Add new stripe', style: TextStyle(color: Colors.grey)),

      ),

    );

  }

}
