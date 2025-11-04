namespace _33_OOP_LINQ
{
    internal class Program
    {
        static void Main(string[] args)
        {
            #region Intro

            ////LINGQ - Language Integrated Query: C#'da veri sorgulama ve manipülasyonu için kullanılan bir özelliktir.

            //List<int> numbers = new List<int>() { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

            ////3ün üzerindeki sayıları filtreleme
            //var newNumbers = numbers.Where(n => n > 3).ToList();

            //var queryNumbers = from n in numbers
            //                   where n > 3
            //                   select n;

            //foreach (var item in newNumbers)
            //{
            //    Console.WriteLine(item);
            //}

            ////Delegate: içerisinde metot referansı tutabilen türlerdir.
            ////referans tipli bir yapıdır
            //numDelegate numDelegate = new numDelegate(Sum); //tekli delegate

            //numDelegate += Substract; //multidelegate, -= ile de çıkarırsın
            //numDelegate(10, 5); //hem toplamı hemde fark metodunu çalıştırır

            //// Predicate: giriş önemli değil ama dönüş tipi boolendır
            //// Func: geriye değer dönen metotları saklar
            //// Action: geriye değer döndürmeyen delegateleri saklar

            //Action<int, int> action = Sum; //geriye void dönen 2 parametreli fonksiyonu ekledik
            //action += Substract;
            //action(10, 10);

            //Func<int, int, int> func = Sum2; // son parametre çıkış tipidir. 2 int parametre giricek. çıkışı int olcak
            //func += Substract2;
            //func(10, 20);
            //func = (a, b) => a * b; //lambda ile çarpma işlemi ekledik
            //func += Bolme;

            //int Topla(int x, int y) => x + y; //lokal fonksiyon
            //Func<int, int, int> func2 = (x, y) => x+y; //üst satırla aynı işi yapar


            //bool isEven(int number) => number % 2 == 0; //lokal fonksiyon
            //Func<int, bool> iseven = x=> x % 2 == 0; //üst satırla aynı işi yapar

            ////Where fonksinu da buna benzer şekilde çalışır
            ////numbers.Where()
            #endregion


            List<Student> students = new List<Student>()
            {
                new Student {Id = 1, Name ="Ahmet", Age = 20, City = "İstanbul" , DepartmentId = 101},
                new Student {Id = 2, Name ="b", Age = 22, City = "Ankara",DepartmentId = 102},
                new Student {Id = 3, Name ="c", Age = 21, City = "İzmir", DepartmentId = 102},
                new Student {Id = 4, Name ="d", Age = 19, City = "İstanbul", DepartmentId = 102},
            };

            List<Department> departments = new List<Department>()
            {
                new Department {Id = 101, Name = "PC" },
                new Department {Id = 102, Name = "Elek" },
                new Department {Id = 103, Name = "Mak" },
            };

            #region Where

            bool denemes(Student student) => student.Age > 20;

            //Method Syntax
            var filteredStudents = students.Where(x => x.Age > 20 && x.City == "İstanbul").ToList(); // where içine deneme yazsan da olur. Tolist demezsek IEnumarble dönüyo. Liste ile çalıştığı içi ekledi

            //Chain metot mantığı: ardarda where yazımı
            students.Where(x => x.Age > 20).Where(x => x.City == "İstanbul");

            foreach (var item in filteredStudents)
            {
                Console.WriteLine(item);
            }


            //Query Syntax
            var filteredStudents2 = from s in students
                                    where s.Age > 20 && s.City == "İstanbul"
                                    select s;
            #endregion

            #region OrderBy
            var sortedList = students.OrderBy(x => x.Age).ToList();
            sortedList = students.OrderBy(x => x.Age).ThenBy(x => x.City).ToList(); // ilk yaşı sıralar. eğer yaşlar aynı ise şehir ismine göre sıralar

            var sortedList2 = from s in students
                              orderby s.Age, s.City ascending // descending
                              select s;
            #endregion

            #region GroupBy
            var groupedStudents = students.GroupBy(x => x.City).ToList();

            foreach (var item in groupedStudents)
            {
                //IGrouping türünden gelir. O yüzden key ile gruplama kriterine erişilir. item.Key değerinde gelir. Bir foreach ile içindeki öğrencilere erişilir
                
                Console.WriteLine(item.Key);
                //item.Sum()
                //item.Count();

                foreach (var student in item)
                {
                    Console.WriteLine(student);

                }
            }

            var groupedStudents2 = from s in students
                                   group s by s.City;

            #endregion

            #region Select

            //StudentDto türünden bir liste döner
            var studentSelect = students.Select(x => new StudentDTO
            {
                Adi = x.Name,
                Sehir = x.City
            }).ToList();


            //Where selecten önce yapılsaydı student üzerinden yapar. ama son aşamada yapılırsa StudentDTO türünden koşul uygular
            //var studentSelect = students.Where().Select(x => new StudentDTO
            //{
            //    Adi = x.Name,
            //    Sehir = x.City
            //})Where().ToList();

            foreach (var item in studentSelect)
            {
                Console.WriteLine(item.Sehir + " " + item.Adi);
                
            }

            //Ananim bir class oluşur. newden sonra bir şey yazmadık
            var studentSelect2 = students.Select(x => new
            {
                Name1 = x.Name,
                City1 = x.City
            }).ToList();

            //Anonim class oluşturur
            var deneme = new { Adi = "sa" };
            //deneme.Adi = "1"; // sonradan atama yapılamaz


            var deneme2 = new StudentDTO { Adi = "sa", Sehir = "sdas" };
            //deneme2.Sehir = "sdgf"; //set tanımlandı değişim yapılabilir
            //deneme2.Adi = "lskjfdkl"; //init tanımlandığı için hata verir

            var deneme3 = new StudentDTO { Adi = "sa", Sehir = "sdas" };

            //record olduğu için eşit çıkar. value type gibi çalışır
            if (deneme2 == deneme3)
                Console.WriteLine("eşit");
            else
                Console.WriteLine("eşit değil");


            var studentSelect3 = from s in students
                                 select new 
                                 {
                                     Adi = s.Name,
                                 };

            #endregion

            #region join

            //ilk parametre: bağlanılacak liste
            //ikinci parametre: ilk listedeki bağlanılacak kolon
            //üçüncü parametre: ikinci listedeki bağlanılacak kolon
            //dördüncü parametre: yeni oluşacak nesne
            var joinedData = students.Join(departments,
                                        s => s.DepartmentId,
                                        d => d.Id,
                                        (s, d) => new
                                        {
                                            //student = s,
                                            //DepartmentName = d

                                            Adi = s.Name,
                                            Yasi = s.Age,
                                            Bolum = d.Name
                                        }).ToList();
            //Oluşan yapı bu
            //    public class JoinedResult
            //    {
            //        public Student student { get; set; }
            //        public Department department { get; set; }
            //}

            //query syntax
            var joinedData2 = from s in students
                              join d in departments
                              on s.DepartmentId equals d.Id
                              select new
                              {
                                  s = s,
                                  d = d
                              };

            #endregion


            #region All
            //where gibi ama tüm koşulların sağlanıp sağlanmadığını kontrol eder
            bool allStudentPassed = students.All(x => x.Age > 18); //tüm yaşlar 18 den büyükse true değilse false
            #endregion

            #region Any
            //where gibi ama en az bir koşulun sağlanıp sağlanmadığını kontrol eder
            bool anyStudentPassed = students.Any(x => x.Age > 18); // en az bir yaş 18 den büyükse true değilse false
            #endregion


            #region Average
            double averageAge = students.Average(x => x.Age);

            #endregion

            #region Count
            var studentCount = students.Count(); //tüm öğrenci sayısı
            var istanbulStudentCount = students.Count(x => x.City == "İstanbul"); //istanbul öğrenci sayısı
            #endregion

            #region Max-Min
            var maxAge = students.Max(x => x.Age);
            var minAge = students.Min(x => x.Age);
            #endregion

            #region Sum
            var totalAge = students.Sum(x => x.Age);

            //Count ile aynı işi yapar
            var numOdAdults = students.Sum(x =>
            {
                if (x.Age >= 18)
                    return 1;
                else
                    return 0;
            });
            #endregion
        }

        #region Intro metot

        //Func hazır bir delegatedir, Action
        public delegate void numDelegate(int a, int b);

        //Delegate'in içine aynı geri dönüş ve parametreye sahip metotlar verilir
        //Abonelik türü delegate örneğidir. Hangi kanallardan bildirim almak istiyosa onu seçtirirsin. seçtikleirni delegate olarak eklersin
        public static void Sum(int a, int b)
        {
            Console.WriteLine("Toplam: " + (a + b));
        }

        public static void Substract(int a, int b)
        {
            Console.WriteLine(a - b);
        }

        public static int Sum2(int a, int b)
        {
            return a + b;
        }

        public static int Substract2(int a, int b)
        {
            return a - b;
        }

        public static int Bolme(int a, int b) => a / b;

        #endregion
    }
}
