import 'package:graphql_book/src/presentation/screens/text_edit/model.dart';

List<BookData> allBooks = [
  BookData(content: allLists, name: 'First Book'),
  BookData(content: allLists, name: 'Second Book'),
  BookData(content: allLists, name: 'Third Book'),
];

List<DraggableList> allLists = [
  DraggableList(
    isAttached: false,
    header: 'What is Lorem Ipsum?',
    items: [
      DraggableListItem(
        isBookmarked: false,
        time: DateTime.fromMillisecondsSinceEpoch(1644573233 * 1000),
        text:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
      ),
    ],
  ),
  DraggableList(
    isAttached: false,
    header: 'Where does it come from?',
    items: [
      DraggableListItem(
        isBookmarked: false,
        time: DateTime.fromMillisecondsSinceEpoch(1618134833 * 1000),
        text:
            'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.',
      ),
      DraggableListItem(
        isBookmarked: false,
        time: DateTime.now(),
        text:
            'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
      ),
    ],
  ),
  DraggableList(
    isAttached: false,
    header: 'Why do we use it?',
    items: [
      DraggableListItem(
        isBookmarked: false,
        time: DateTime.now(),
        text:
            'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).',
      ),
    ],
  ),
];
