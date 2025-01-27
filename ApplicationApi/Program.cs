namespace ApplicationApi
{
    public class Program
    {
        // The following constant is replaced during the build process, it is not to be changed manually.
        public const string X_VERSION = "unknown-development";

        public static void Main(string[] args)
        {
            Console.WriteLine($"X_VERSION: {X_VERSION}");

            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
            builder.Services.AddOpenApi();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.MapOpenApi();
            }

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}
