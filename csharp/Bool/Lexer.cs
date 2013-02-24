using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bool
{
    partial class Lexer
    {
        public Lexer(string text) : this(GetStreamFromString(text))
        {
        }

        private static Stream GetStreamFromString(string text)
        {
            return new MemoryStream(Encoding.UTF8.GetBytes(text));
        }
    }
}
