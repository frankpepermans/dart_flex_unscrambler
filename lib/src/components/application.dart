part of dart_flex_unscrambler;

class MainApplication extends SkinnableComponent {
  
  // local props
  String _currentWord = '';
  int _currentBlanks = 0;
  Dictionary dictionary;
  
  // named UI components in the skin
  HGroup wordContainer;
  TileGroup letterGroup;
  
  // bindable resultset
  @observable ObservableList<WordBinary> matchingWords = new ObservableList<WordBinary>();
  
  // path to the view skin file
  @Skin('dart_flex_unscrambler|lib/src/xml/application.xml')
  MainApplication() : super() {
    loadWordList();
    
    // set skin's initial state
    currentSkinStates = const <SkinState>[const SkinState('loadingState')];
  }
  
  // called whenever a named skin UI part is created
  @override
  void partAdded(IUIWrapper part) {
  }
  
  // adds a letter to the scrambled word
  void addLetter(String letter) {
    _currentWord += letter;
    
    addWordButton(letter);
    
    findMatches();
  }
  
  // adds a blank letter to the scrambled word
  void addBlank() {
    _currentBlanks++;
    
    addWordButton(' ');
    
    findMatches();
  }
  
  // represent the letters of the scrambled word by buttons
  void addWordButton(String C) => wordContainer.addComponent(
    new Button()
      ..cssClasses = ['word']
      ..width = 34
      ..height = 34
      ..label = C
      ..onButtonClick.listen(
        (FrameworkEvent E) {
          final Button B = E.currentTarget as Button;
          final String char = B.label;
          
          if (char == ' ') _currentBlanks--;
          else _currentWord = _currentWord.replaceFirst(char, '');
          
          wordContainer.removeComponent(B);
          
          findMatches();
        }     
      )
  );
  
  // run the algo to find matches
  void findMatches() {
    final bool hasWord = (_currentWord.isNotEmpty || _currentBlanks > 0);
    
    currentSkinStates = hasWord ? const <SkinState>[const SkinState('resultState')] : const <SkinState>[const SkinState('emptyWordState')];
    
    if (dictionary != null) {
      matchingWords.clear();
      
      matchingWords.addAll(dictionary.match(_currentWord.toLowerCase(), _currentBlanks));
      
      matchingWords.sort((WordBinary a, WordBinary b) => b.word.length.compareTo(a.word.length));
    }
  }
  
  // loads the full word list
  void loadWordList() {
    HttpRequest.request('sowpods.txt', method: 'GET', responseType: 'text').then(
      (HttpRequest R) {
        dictionary = new Dictionary(R.responseText);
        
        currentSkinStates = const <SkinState>[const SkinState('emptyWordState')];
      }
    );
  }
}