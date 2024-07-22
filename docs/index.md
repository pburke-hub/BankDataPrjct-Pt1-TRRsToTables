---
title: Home
layout: home
---

<!-- If below callout doesn't work, proba needs to be wrapped in a div with markdown="1" --> 
{.ghrepo-callout}
Just a test home page atm.

I've been wanting to get a better grip of indenting. Especially, using bullet points which continue over multiple line breaks / lines.  
(NB: I ended the above in x2 spaces.) However, I'm ending-line at end of this sentence without any spaces.
Anyway, to research I looked at https://kramdown.gettalong.org/syntax.html and using spaces instead of tabs appears to be important.

(Ended the above paragraph/line without spaces, but do have a blank line separting from here/this). In particular, it seems like I may only be allowed to indent by up to 3 spaces, and trying to achieve e.g. 6-space indentations, simply isn't possible.  

(Ended the above paragraph/line with x2 spaces, AND do have a blank line separting from here/this). So without further ado, let's play around.

Cool.

   ### Header with x3 spaces beforehand

Wonder if that caused indentation of the above header?

### Header without indentation.  
But ended with x2 spaces.

This⋅para⋅line⋅starts⋅at⋅the⋅first⋅column.⋅However,
      the⋅following⋅lines⋅can⋅be⋅indented⋅any⋅number⋅of⋅spaces/tabs. (Started with x6 spaces, above ended with no spaces)
   The⋅para⋅continues⋅here. (Started with x3 spaces, above ended with no spaces)

  This⋅is⋅another⋅paragraph,⋅not⋅connected⋅to⋅the⋅above⋅one.⋅But⋅⋅
with⋅a⋅hard⋅line⋅break.⋅\\
And⋅another⋅one.


### Okay, let's start playing with lists:

1. The first list marker in a list may be indented up to three spaces.
1. Hmm ... Does that mean that above "1. " consumes 3 spaces, and thus is the maximum allowed indentation.  
1. Surely not?!
1. Hmm ...

* Only a blank line separates these lists. However, a "* " uses only x2 spaces. So I expect this is treated as the end of the above 4-point list's block, and the beginning of a new block/element.  
  Let's test that. (NB: this line/para isn't a list. However, it was indented by the same x2 spaces).

Okay, maybe what is being said is that an indent-level / tab-character/tab-length will be inferred to be either x2 or x3 spaces, and no other lengths. E.g.  

 1. Item 1. The "I" started at character 4, so I expect our tab length ='s 2 for this list div/block.
   2. Okay. Now instead of x1 space before the point, I used x3.
      3.  Now, x10 spaces/characters are indenting. So will this be x5 indented?
 4. Back to just a single space before the "4. B".

Cool. That's a bit of stuff to learn from for now.

Although  

I'm sure there's still more to test/learn.

E.g. We haven't even experimented with non-list elements inside a list's block/div.







