part of dart_flex_unscrambler;

class MainApplication extends SkinnableComponent {
  
  String _currentWord = '';
  int _currentBlanks = 0;
  Dictionary dictionary;
  
  HGroup wordContainer;
  TileGroup letterGroup;
  
  @observable ObservableList<WordBinary> matchingWords = new ObservableList<WordBinary>();
  
  @Skin('dart_flex_unscrambler|lib/src/xml/application.xml')
  MainApplication() : super() {
    loadWordList();
    
    currentSkinStates = const <SkinState>[const SkinState('loadingState')];
  }
  
  @override
  void partAdded(IUIWrapper part) {
  }
  
  void addLetter(String letter) {
    _currentWord += letter;
    
    addWordButton(letter);
    
    findMatches();
  }
  
  void addBlank() {
    _currentBlanks++;
    
    addWordButton(' ');
    
    findMatches();
  }
  
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
  
  void findMatches() {
    final bool hasWord = (_currentWord.isNotEmpty || _currentBlanks > 0);
    
    currentSkinStates = hasWord ? const <SkinState>[const SkinState('resultState')] : const <SkinState>[const SkinState('emptyWordState')];
    
    if (dictionary != null) {
      matchingWords.clear();
      
      matchingWords.addAll(dictionary.match(_currentWord.toLowerCase(), _currentBlanks));
      
      matchingWords.sort((WordBinary a, WordBinary b) => b.word.length.compareTo(a.word.length));
    }
  }
  
  void loadWordList() {
    HttpRequest.request('sowpods.txt', method: 'GET', responseType: 'text').then(
      (HttpRequest R) {
        dictionary = new Dictionary(R.responseText);
        
        currentSkinStates = const <SkinState>[const SkinState('emptyWordState')];
      }
    );
  }
}