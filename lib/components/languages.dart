class Language{
  final int id;
  final String name;
  final String Languagecode;


   Language(this.id,this.name,this.Languagecode);

   static List<Language> languageList(){
     return <Language>[
       Language(1,"English","en"),
       Language(2, "Arabic", "ar")
     ];
   }

}