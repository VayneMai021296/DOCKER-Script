// Cập nhật nội dung file Program.cs để in ma trận có ký tự '|' và cách đều
// ogram_cs_content = """\
using System;

class Program
{
    static void Main()
    {
        Console.Write("Nhập số hàng: ");
        if (!int.TryParse(Console.ReadLine(), out int rows) || rows <= 0)
        {
            Console.WriteLine("Số hàng không hợp lệ! Vui lòng nhập số nguyên dương.");
            return;
        }

        Console.Write("Nhập số cột: ");
        if (!int.TryParse(Console.ReadLine(), out int cols) || cols <= 0)
        {
            Console.WriteLine("Số cột không hợp lệ! Vui lòng nhập số nguyên dương.");
            return;
        }

        int[,] matrix = new int[rows, cols];
        int counter = 1;

        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < cols; j++)
            {
                matrix[i, j] = counter++;
            }
        }

        Console.WriteLine("\\nMa trận được đánh số:");
        for (int i = 0; i < rows; i++)
        {
            Console.Write("|");
            for (int j = 0; j < cols; j++)
            {
                Console.Write($" {matrix[i, j],4} |"); // Căn chỉnh cách đều 4 ký tự
            }
            Console.WriteLine();
        }
    }
}