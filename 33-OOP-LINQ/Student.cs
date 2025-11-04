namespace _33_OOP_LINQ
{
    public class Student
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Age { get; set; }
        public string City { get; set; }
        public int DepartmentId { get; set; }

        public override string ToString()
        {
            return $"Id: {Id}, Name: {Name}, Age: {Age}, City: {City}, DepartmentId: {DepartmentId}";
        }
    }
}
