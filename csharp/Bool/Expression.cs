using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bool
{
    public class Expression
    {
    }

    public class And : Expression
    {
        public And(Expression expr1, Expression expr2)
        {
            throw new NotImplementedException();
        }
    }

    public class Or : Expression
    {
        public Or(Expression expr1, Expression expr2)
        {
            throw new NotImplementedException();
        }
    }

    public class Not : Expression
    {
        public Not(Expression expr1)
        {
            throw new NotImplementedException();
        }
    }
}
