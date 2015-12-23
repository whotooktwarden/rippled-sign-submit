# rippled-sign-submit

TLDR; A template ripple.yml file and a ruby script for signing and submitting Ripple transactions using rippled.

  1.  Preamble
  
   This ruby script was authored by Taylor Warden to be released free of charge to the community Ripple developers


   >Many thanks to julianeon for providing a template Ruby script!!
   
   >Many thanks to JoelKatz for putting up with my stupid syntax/rippled questions!!
   
   >Many thanks to ninobrooks for assisting with unix permission issues!!

   >And finally thank you to Mr. Data from  [coinpayments.net](https://www.coinpayments.net/index.php?ref=ee25108a996abb3fdf7b07dfa429c2f9]coinpayments.net) for your services, all of your support, and [for adding this resource to your site](https://www.coinpayments.net/merchant-tools-ipn)!!

   submit.rb and ripple.yml are provided AS-IS and WITHOUT WARRANTY

   This package is released under a Creative Commons Attribution 4.0 International License, please refer to the LICENSE file for more information.

        I, TAYLOR WARDEN, HEREBY CLAIM NO RESPONSIBILITY THEREIN FOR ANY INDIVIDUAL, 
        INDIVIDUALS, ENTITY, OR ENTITIES THAT MAY RECEIVE LEGAL ACTION, DIRECTLY OR INDIRECTLY,
        FOR THE USAGE OF THIS OR ANY PORTION OF THESE DOCUMENTS, IN PART OR IN FULL.  
        IN THE CASE OF A CIVIL LAWSUIT BEING ISSUED REGARDING THE USAGE OF THESE MATERIALS,
        THE RESULTING LAWSUIT WILL BE HEARD FROM WITHIN A COURT OF ONTARIO, CANADA.
        
  2. Table of Contents
  
     Preamble

     Table of Contents

     Purpose

     Reference Materials

     Donations

     Join the Ripple Community

  3. Purpose
  
     The purpose of this package is to assist those developers who are looking to sign and submit Ripple transactions
     from their server after receiving a deposit of any kind of asset.  Although you can manually issue IOUs with this      script via the command line, this package is meant to be used with the 
     [coinpayments.net](https://www.coinpayments.net/index.php?ref=ee25108a996abb3fdf7b07dfa429c2f9) Instant Payment Notification API (see Reference Materials).  

     Command-line Usage:
     
       After you have set your Issuer and Account in the submit.rb file, add your Issuer's secret to the ripple.yml          file.  You can now run commands in this format to issue IOUs:
       
       ruby submit.rb Ripple_Address Amount Currency Transaction_ID
       
  4.  Reference Materials

      This package is meant to be used with the QuickGatewayKit:
      
      [QGK on GitHub](https://github.com/whotooktwarden/QuickGatewayKit)
      
      [QGK Showcase Site](http://quickgatewaykit.org/)
      
      [QGK Blog](http://quickgatewaykit.org/blog/)
      
    
      This package can be used for automatically accepting cryptocurrencies using [coinpayments.net](https://www.coinpayments.net/index.php?ref=ee25108a996abb3fdf7b07dfa429c2f9):
      
      [Instant Payment Notifications (IPN) API](https://www.coinpayments.net/merchant-tools-ipn)
      
      [IPN Template in PHP](https://www.coinpayments.net/downloads/cpipn.phps)
      
      [The QuickGatewayKit: IPN Example Scripts](https://github.com/whotooktwarden/QuickGatewayKit)

      Related Threads:
      
      [rippled sign, invalid parameters](https://forum.ripple.com/viewtopic.php?f=2&t=15599)
      
      [Invalid field 'tx_json.Amount'](https://forum.ripple.com/viewtopic.php?f=2&t=15600)
      
      [rippled submit blob, error -92 terPRE_SEQ](https://forum.ripple.com/viewtopic.php?f=2&t=15632)

  7.  Donations
        
    Please consider donating a small amount of XRP or Bitcoin to:
    https://www.bountysource.com/teams/qgk
        
    for the continued support/development of this resource if it was was helpful for starting your Ripple-based or        Cryptocurrency Exchange business.
       
  8.  Join the Ripple Community!
       
    Join us at the official Ripple forums!  https://forum.ripple.com/
