using Microsoft.AspNetCore.Html;
using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Text;

namespace FirstProject.Common
{
    public static class PagingHtmlHelpers
    {
        public static IHtmlContent PageLinks
        (this IHtmlHelper htmlHelper, PageInfo pageInfo)
        {
            StringBuilder pagingTags = new StringBuilder();
            //Prev Page
            int sp;
            int ep;
            if (pageInfo.CurrentPage > 1)
            {
                pagingTags.Append(GetTagString
                                 ("Prev ", pageInfo.CurrentPage.ToString(), (pageInfo.CurrentPage - 1).ToString()));
            }

            //var totalNumber =  pageInfo.TotalItems / pageInfo.ItemsPerPage;
            var totalNumber = (int)Math.Ceiling((decimal)pageInfo.TotalItems / pageInfo.ItemsPerPage);

            #region by 5
            //if (pageInfo.CurrentPage % 5 == 0)
            //{
            //    sp = (pageInfo.CurrentPage / 5 * 5) - 4;
            //}
            //else
            //{
            //    sp = (pageInfo.CurrentPage - (pageInfo.CurrentPage % 5)) + 1;
            //}
            //ep = sp + 4;
            ////Page Numbers
            //for (int i = sp; i <= ep; i++)
            //{
            //    if (i <= totalNumber)
            //    {
            //        pagingTags.Append(GetTagString(" " + i.ToString() + " ", PageUrl(i), pageInfo.CurrentPage.ToString()));
            //    }

            //}

            #endregion

            #region by 3
            if (pageInfo.CurrentPage % 3 == 0)
            {
                sp = (pageInfo.CurrentPage / 3 * 3) - 2;
            }
            else
            {
                sp = (pageInfo.CurrentPage - (pageInfo.CurrentPage % 3)) + 1;
            }
            ep = sp + 2;
            //Page Numbers
            for (int i = sp; i <= ep; i++)
            {
                if (i <= totalNumber)
                {
                    pagingTags.Append(GetTagString(" " + i.ToString() + " ", pageInfo.CurrentPage.ToString(), " " + i.ToString() + " "));
                }
            }
            #endregion

            //Next Page
            if (pageInfo.CurrentPage < pageInfo.LastPage)
            {
                pagingTags.Append(GetTagString
                                 (" Next", pageInfo.CurrentPage.ToString(), (pageInfo.CurrentPage + 1).ToString()));
            }
            //paging tags
            return new HtmlString(pagingTags.ToString());
        }

        private static string GetTagString(string innerHtml, string currPage, string currPage1)
        {
            TagBuilder tag = new TagBuilder("buttton"); // Construct an <a> tag
            if (innerHtml.Trim() == currPage)
            {
                tag.MergeAttribute("class", "anchorstyle isActive");
            }
            else
            {
                tag.MergeAttribute("class", "anchorstyle");
            }
            tag.MergeAttribute("onClick", "paginationData(" + currPage1.Trim() + ")");
            tag.InnerHtml.Append(" " + innerHtml + "  ");
            using (var sw = new System.IO.StringWriter())
            {
                tag.WriteTo(sw, System.Text.Encodings.Web.HtmlEncoder.Default);
                return sw.ToString();
            }
        }
    }
}