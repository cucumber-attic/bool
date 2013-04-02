#include <ruby.h>
#include "ast.h"
#include "unused.h"

VALUE eSyntaxError;
VALUE cToken;
VALUE cVar;
VALUE cAnd;
VALUE cOr;
VALUE cNot;

static VALUE transform_token(Token *token) {
    return rb_funcall(cToken, rb_intern("new"), 5, 
        rb_str_new2(token->value), 
        INT2FIX(token->first_line),
        INT2FIX(token->last_line),
        INT2FIX(token->first_column),
        INT2FIX(token->last_column)
    );
}

/**
 * Transforms the C AST to a Ruby AST.
 */
static VALUE transform(Node *node) {
    VALUE token = transform_token(node->token);

    switch (node->type) {
    case eVAR:
        return rb_funcall(cVar, rb_intern("new"), 1, token);
    case eAND:
        return rb_funcall(cAnd, rb_intern("new"), 3, token, transform(((And*)node)->left), transform(((And*)node)->right));
    case eOR:
        return rb_funcall(cOr,  rb_intern("new"), 3, token, transform(((Or*)node)->left), transform(((Or*)node)->right));
    case eNOT:
        return rb_funcall(cNot, rb_intern("new"), 2, token, transform(((Not*)node)->operand));
    default:
        rb_raise(rb_eArgError, "Should never happen");
        return 0;
    }
}

static VALUE Bool_parse(VALUE klass, VALUE r_expr) {
    VALUE exception;
    Node* ast;
    char* expr;

    UNUSED(klass);

    // TODO: Verify that r_expr really is a Ruby String
    expr = RSTRING_PTR(r_expr);
    ast = parse_ast(expr);

    if(ast != NULL) {
        VALUE result = transform(ast);
        free_ast(ast);
        return result;
    } else {
        VALUE token = transform_token(last_error.token);
        exception = rb_funcall(
            eSyntaxError, rb_intern("new"), 2,
            rb_str_new2(last_error.message), 
            token
        );
        rb_exc_raise(exception);
    }
}

void Init_bool_ext() {
    VALUE mBool;
    VALUE cNode;
    VALUE rb_eStandardError;

    mBool = rb_define_module("Bool");
    rb_eStandardError = rb_const_get(rb_cObject, rb_intern("StandardError"));
    eSyntaxError = rb_define_class_under(mBool, "SyntaxError", rb_eStandardError);
    cNode = rb_define_class_under(mBool, "Node", rb_cObject);

    cToken  = rb_define_class_under(mBool, "Token", rb_cObject);
    cVar    = rb_define_class_under(mBool, "Var", cNode);
    cAnd    = rb_define_class_under(mBool, "And", cNode);
    cOr     = rb_define_class_under(mBool, "Or",  cNode);
    cNot    = rb_define_class_under(mBool, "Not", cNode);

    rb_define_singleton_method(mBool, "parse", Bool_parse, 1);
}

