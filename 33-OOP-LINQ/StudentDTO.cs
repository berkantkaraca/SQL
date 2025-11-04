namespace _33_OOP_LINQ
{
    //Dto recor tercih edilebilir. Sonradan değişemezsin. Immutiubale özelliği vardır. burda set yerine init kullanılır bu özellik için
    public record StudentDTO
    {
        public string Adi { get; init; }
        public string Sehir { get; set; }
  
    }
}
