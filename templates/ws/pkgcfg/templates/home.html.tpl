<!DOCTYPE html>
<!--
  - @ORG@ @PKG_NAME@ Source Documentation Index.
  - @THIS_DATE@ @THIS_TIME@
  -->
<html>
  <head>
    <title>@ORG_FQ@ @PKG_NAME@-@PKG_VER@ PyDoc</title>

    <meta charset=utf-8">
    <meta name="language" content="english">
    <meta name="author" content="@AUTHOR@">
    <meta name="copyright" content="&copy; @THIS_YEAR@ @ORG_FQ@">

    <link rel="icon" type="image/png" href="@FAVICON@">

<!-- inline styles -->
<style type="text/css">
body, table, div, p, dl {
  font-family: Lucida Grande, Verdana, Geneva, Arial, sans-serif;
  font-size: medium;
}

/* @group Heading Levels */

h1 {
  text-align: left;
  font-size: 150%;
  border-bottom: 3px solid #990000;
}

h1:before {
  content: url(@ORG_LOGO@);
  padding-right: 10px;
  width: 96px;
  height: 48px;
}

table.tbl1
{
  font-size: 14px;
  padding: 0 10px 5px 0;
}

table.tbl1 td
{
  text-align: left;
  padding: 0 5px 5px 0;
}

table.tbl1 td.num
{
  text-align: right;
}

table.tbl1 td.ref
{
  text-align: left;
}

table.tbl1 td.ref a
{
  font-weight: bold;
  text-decoration: underline;
}

table.tbl1 td.caption
{
  text-align: center;
  font-style: italic;
}
</style>

  </head>

  <body>
    <h1>
    @PKG_NAME@ v@PKG_VER@ Documentation
    </h1>

    <h3>Release Files</h3>
    @REL_HREF_ITER:<p class='ref'><a href='{}'>{}</a></p>@
    
    <h3>Doxygen Generated Source Documentation</h3>
    @DOXY_HREF:<p class='rel'><a href='{}'>{}</a></p>@

    <h3>Pydoc Generated Python Source Documentation</h3>
    @PYDOC_HREF:<p class='rel'><a href='{}'>{}</a></p>@

    <h3>Papers</h3>
    @PUB_HREF:<p class='rel'><a href='{}'>{}</a></p>@

    <br>

    <hr size="1">

    <address style="font-size: small">
      <div style="float:left; font-size:small">
          &copy;@THIS_YEAR@ @ORG_FQ@
          &nbsp; &nbsp;
          <a href="@ORG_URL@">@ORG_URL@</a>
      </div>
      <div style="float:right; font-size:small">
    @THIS_DATE@
      </div>
    </address>
  </body>
</html>
