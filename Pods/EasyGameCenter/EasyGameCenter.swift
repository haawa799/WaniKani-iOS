//
//  GameCenter.swift
//
//  Created by Yannick Stephan DaRk-_-D0G on 19/12/2014.
//  YannickStephan.com
//
//	iOS 7.0+ & iOS 8.0+
//
//  The MIT License (MIT)
//  Copyright (c) 2015 Red Wolf Studio & Yannick Stephan
//  http://www.redwolfstudio.fr
//  http://yannickstephan.com
//  Version 2.0 for Swift 2.0

import Foundation
import GameKit
import SystemConfiguration

/**
TODO List
- REMEMBER report plusieur score  pour plusieur leaderboard  en array
*/

// Protocol Easy Game Center
@objc protocol EGCDelegate:NSObjectProtocol {
    /**
    Authentified, Delegate Easy Game Center
    */
    optional func EGCAuthentified(authentified:Bool)
    /**
    Not Authentified, Delegate Easy Game Center
    */
    //optional func EGCNotAuthentified()
    /**
    Achievementes in cache, Delegate Easy Game Center
    */
    optional func EGCInCache()
    /**
    Method called when a match has been initiated.
    */
    optional func EGCMatchStarted()
    /**
    Method called when the device received data about the match from another device in the match.
    
    - parameter match:          GKMatch
    - parameter didReceiveData: NSData
    - parameter fromPlayer:     String
    */
    optional func EGCMatchRecept(match: GKMatch, didReceiveData: NSData, fromPlayer: String)
    /**
    Method called when the match has ended.
    */
    optional func EGCMatchEnded()
    /**
    Cancel match
    */
    optional func EGCMatchCancel()
}

// MARK: - Public Func
extension EGC {
    /**
    CheckUp Connection the new
    
    - returns: Bool Connection Validation
    
    */
    static var isConnectedToNetwork: Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
}

/// Easy Game Center Swift
public class EGC: NSObject, GKGameCenterControllerDelegate, GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKLocalPlayerListener {
    
    /*####################################################################################################*/
    /*                                    Private    Instance                                             */
    /*####################################################################################################*/
    
    /// Achievements GKAchievement Cache
    private var achievementsCache:[String:GKAchievement] = [String:GKAchievement]()
    
    /// Achievements GKAchievementDescription Cache
    private var achievementsDescriptionCache = [String:GKAchievementDescription]()
    
    /// Save for report late when network working
    private var achievementsCacheShowAfter = [String:String]()
    
    /// Checkup net and login to GameCenter when have Network
    private var timerNetAndPlayer:NSTimer?
    
    /// Debug mode for see message
    private var debugModeGetSet:Bool = false
    
    static var showLoginPage:Bool = true
    
    /// The match object provided by GameKit.
    private var match: GKMatch?
    private var playersInMatch = Set<GKPlayer>()
    public var invitedPlayer: GKPlayer?
    public var invite: GKInvite?
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /*####################################################################################################*/
    /*                                    Singleton Public Instance                                       */
    /*####################################################################################################*/
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "authenticationChanged", name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }
    /**
    Static EGC
    
    */
    struct Static {
        /// Async EGC
        static var onceToken: dispatch_once_t = 0
        /// Instance of EGC
        static var instance: EGC? = nil
        /// Delegate of UIViewController
        static weak var delegate: UIViewController? = nil
    }
    /**
    Start Singleton GameCenter Instance
    
    */
    public class func sharedInstance(delegate:UIViewController)-> EGC {
        if Static.instance == nil {
            dispatch_once(&Static.onceToken) {
                Static.instance = EGC()
                Static.delegate = delegate
                Static.instance!.loginPlayerToGameCenter()
            }
        }
        return Static.instance!
    }
    /// Delegate UIViewController
    class var delegate: UIViewController {
        get {
            do {
                let delegateInstance = try EGC.sharedInstance.getDelegate()
                return delegateInstance
            } catch  {
                EGCError.NoDelegate.errorCall()
                fatalError("Dont work\(error)")
            }
        }
        
        set {
            guard newValue != EGC.delegate else {
                return
            }
            Static.delegate = EGC.delegate
            
            EGC.printLogEGC("New delegate UIViewController is \(_stdlib_getDemangledTypeName(newValue))\n")
        }
    }
    
    /*####################################################################################################*/
    /*                                      Public Func / Object                                          */
    /*####################################################################################################*/
    
    public class var debugMode:Bool {
        get {
            return EGC.sharedInstance.debugModeGetSet
        }
        set {
            EGC.sharedInstance.debugModeGetSet = newValue
        }
    }
    /**
    If player is Identified to Game Center
    
    - returns: Bool is identified
    
    */
    public static var isPlayerIdentified: Bool {
        get {
            return GKLocalPlayer.localPlayer().authenticated
        }
    }
    /**
    Get local player (GKLocalPlayer)
    
    - returns: Bool True is identified
    
    */
    static var localPayer: GKLocalPlayer {
        get {
            return GKLocalPlayer.localPlayer()
        }
    }
    //   class func getLocalPlayer() -> GKLocalPlayer {  }
    /**
    Get local player Information (playerID,alias,profilPhoto)
    
    :completion: Tuple of type (playerID:String,alias:String,profilPhoto:UIImage?)
    
    */
    class func getlocalPlayerInformation(completion completionTuple: (playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)?) -> ()) {
        
        guard EGC.isConnectedToNetwork else {
            completionTuple(playerInformationTuple: nil)
            EGCError.NoConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            completionTuple(playerInformationTuple: nil)
            EGCError.NotLogin.errorCall()
            return
        }
        
        EGC.localPayer.loadPhotoForSize(GKPhotoSizeNormal, withCompletionHandler: {
            (image, error) in
            
            var playerInformationTuple:(playerID:String,alias:String,profilPhoto:UIImage?)
            playerInformationTuple.profilPhoto = nil
            
            playerInformationTuple.playerID = EGC.localPayer.playerID!
            playerInformationTuple.alias = EGC.localPayer.alias!
            if error == nil { playerInformationTuple.profilPhoto = image }
            completionTuple(playerInformationTuple: playerInformationTuple)
        })
    }
    /*####################################################################################################*/
    /*                                      Public Func Show                                              */
    /*####################################################################################################*/
    
    /**
    Show Game Center Player Achievements
    
    - parameter completion: Viod just if open Game Center Achievements
    */
    public class func showGameCenterAchievements(completion: ((isShow:Bool) -> Void)? = nil) {
        
        guard EGC.isConnectedToNetwork else {
            if completion != nil { completion!(isShow:false) }
            EGCError.NoConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            if completion != nil { completion!(isShow:false) }
            EGCError.NotLogin.errorCall()
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = Static.instance
        gc.viewState = GKGameCenterViewControllerState.Achievements
        
        var delegeteParent:UIViewController? = EGC.delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = EGC.delegate
        }
        delegeteParent!.presentViewController(gc, animated: true, completion: {
            if completion != nil { completion!(isShow:true) }
        })
    }
    /**
    Show Game Center Leaderboard
    
    - parameter leaderboardIdentifier: Leaderboard Identifier
    - parameter completion:            Viod just if open Game Center Leaderboard
    */
    public class func showGameCenterLeaderboard(leaderboardIdentifier leaderboardIdentifier :String, completion: ((isShow:Bool) -> Void)? = nil) {
        
        guard leaderboardIdentifier != "" else {
            EGCError.Empty.errorCall()
            if completion != nil { completion!(isShow:false) }
            return
        }
        
        guard EGC.isConnectedToNetwork else {
            EGCError.NoConnection.errorCall()
            if completion != nil { completion!(isShow:false) }
            return
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            if completion != nil { completion!(isShow:false) }
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = Static.instance
        gc.leaderboardIdentifier = leaderboardIdentifier
        gc.viewState = GKGameCenterViewControllerState.Leaderboards
        
        var delegeteParent:UIViewController? = EGC.delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = EGC.delegate
        }
        delegeteParent!.presentViewController(gc, animated: true, completion: {
            if completion != nil { completion!(isShow:true) }
        })
        
    }
    /**
    Show Game Center Challenges
    
    - parameter completion: Viod just if open Game Center Challenges
    
    */
    public class func showGameCenterChallenges(completion: ((isShow:Bool) -> Void)? = nil) {
        
        guard EGC.isConnectedToNetwork else {
            if completion != nil { completion!(isShow:false) }
            EGCError.NoConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            if completion != nil { completion!(isShow:false) }
            EGCError.NotLogin.errorCall()
            return
        }
        
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate =  Static.instance
        gc.viewState = GKGameCenterViewControllerState.Challenges
        
        var delegeteParent:UIViewController? =  EGC.delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent =  EGC.delegate
        }
        delegeteParent!.presentViewController(gc, animated: true, completion: {
            () -> Void in
            
            if completion != nil { completion!(isShow:true) }
        })
        
    }
    /**
    Show banner game center
    
    - parameter title:       title
    - parameter description: description
    - parameter completion:  When show message
    
    */
    public class func showCustomBanner(title title:String, description:String,completion: (() -> Void)? = nil) {
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return
        }
        
        GKNotificationBanner.showBannerWithTitle(title, message: description, completionHandler: completion)
    }
    /**
    Show page Authentication Game Center
    
    - parameter completion: Viod just if open Game Center Authentication
    
    */
    public class func showGameCenterAuthentication(completion: ((result:Bool) -> Void)? = nil) {
        if completion != nil {
            completion!(result: UIApplication.sharedApplication().openURL(NSURL(string: "gamecenter:")!))
        }
    }
    
    /*####################################################################################################*/
    /*                                      Public Func LeaderBoard                                       */
    /*####################################################################################################*/
    
    /**
    Get Leaderboards
    
    - parameter completion: return [GKLeaderboard] or nil
    
    */
    public class func getGKLeaderboard(completion completion: ((resultArrayGKLeaderboard:Set<GKLeaderboard>?) -> Void)) {
        
        guard EGC.isConnectedToNetwork else {
            completion(resultArrayGKLeaderboard: nil)
            EGCError.NoConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            completion(resultArrayGKLeaderboard: nil)
            EGCError.NotLogin.errorCall()
            return
        }
        
        GKLeaderboard.loadLeaderboardsWithCompletionHandler {
            (leaderboards, error) in
            
            guard EGC.isPlayerIdentified else {
                completion(resultArrayGKLeaderboard: nil)
                EGCError.NotLogin.errorCall()
                return
            }
            
            guard let leaderboardsIsArrayGKLeaderboard = leaderboards as [GKLeaderboard]? else {
                completion(resultArrayGKLeaderboard: nil)
                EGCError.Error(error?.localizedDescription).errorCall()
                return
            }
            
            completion(resultArrayGKLeaderboard: Set(leaderboardsIsArrayGKLeaderboard))
            
        }
    }
    /**
    Reports a  score to Game Center
    
    - parameter The: score Int
    - parameter Leaderboard: identifier
    - parameter completion: (bool) when the score is report to game center or Fail
    
    
    */
    public class func reportScoreLeaderboard(leaderboardIdentifier leaderboardIdentifier:String, score: Int) {
        guard EGC.isConnectedToNetwork else {
            EGCError.NoConnection.errorCall()
            return
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return
        }
        
        let gkScore = GKScore(leaderboardIdentifier: leaderboardIdentifier)
        gkScore.value = Int64(score)
        gkScore.shouldSetDefaultLeaderboard = true
        GKScore.reportScores([gkScore], withCompletionHandler: nil)
    }
    /**
    Get High Score for leaderboard identifier
    
    - parameter leaderboardIdentifier: leaderboard ID
    - parameter completion:            Tuple (playerName: String, score: Int, rank: Int)
    
    */
    public class func getHighScore(
        leaderboardIdentifier leaderboardIdentifier:String,
        completion:((playerName:String, score:Int,rank:Int)? -> Void)
        ) {
            EGC.getGKScoreLeaderboard(leaderboardIdentifier: leaderboardIdentifier, completion: {
                (resultGKScore) in
                
                guard let valGkscore = resultGKScore else {
                    completion(nil)
                    return
                }
                
                let rankVal = valGkscore.rank
                let nameVal  = EGC.localPayer.alias!
                let scoreVal  = Int(valGkscore.value)
                completion((playerName: nameVal, score: scoreVal, rank: rankVal))
                
            })
    }
    /**
    Get GKScoreOfLeaderboard
    
    - parameter completion: GKScore or nil
    
    */
    public class func  getGKScoreLeaderboard(leaderboardIdentifier leaderboardIdentifier:String, completion:((resultGKScore:GKScore?) -> Void)) {
        
        guard leaderboardIdentifier != "" else {
            EGCError.Empty.errorCall()
            completion(resultGKScore:nil)
            return
        }
        
        guard EGC.isConnectedToNetwork else {
            EGCError.NoConnection.errorCall()
            completion(resultGKScore: nil)
            return
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            completion(resultGKScore: nil)
            return
        }
        
        let leaderBoardRequest = GKLeaderboard()
        leaderBoardRequest.identifier = leaderboardIdentifier
        
        leaderBoardRequest.loadScoresWithCompletionHandler {
            (resultGKScore, error) in
            
            guard error == nil && resultGKScore != nil else {
                completion(resultGKScore: nil)
                return
            }
            
            completion(resultGKScore: leaderBoardRequest.localPlayerScore)
            
        }
    }
    /*####################################################################################################*/
    /*                                      Public Func Achievements                                      */
    /*####################################################################################################*/
    /**
    Get Tuple ( GKAchievement , GKAchievementDescription) for identifier Achievement
    
    - parameter achievementIdentifier: Identifier Achievement
    
    - returns: (gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?
    
    */
    public class func getTupleGKAchievementAndDescription(achievementIdentifier achievementIdentifier:String,completion completionTuple: ((tupleGKAchievementAndDescription:(gkAchievement:GKAchievement,gkAchievementDescription:GKAchievementDescription)?) -> Void)) {
        
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            completionTuple(tupleGKAchievementAndDescription: nil)
            return
        }
        
        let achievementGKScore = EGC.sharedInstance.achievementsCache[achievementIdentifier]
        let achievementGKDes =  EGC.sharedInstance.achievementsDescriptionCache[achievementIdentifier]
        
        guard let aGKS = achievementGKScore, let aGKD = achievementGKDes else {
            completionTuple(tupleGKAchievementAndDescription: nil)
            return
        }
        
        completionTuple(tupleGKAchievementAndDescription: (aGKS,aGKD))
        
    }
    /**
    Get Achievement
    
    - parameter identifierAchievement: Identifier achievement
    
    - returns: GKAchievement Or nil if not exist
    
    */
    public class func getAchievementForIndentifier(identifierAchievement identifierAchievement : NSString) -> GKAchievement? {
        
        guard identifierAchievement != "" else {
            EGCError.Empty.errorCall()
            return nil
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return nil
        }
        
        guard let achievementFind = EGC.sharedInstance.achievementsCache[identifierAchievement as String] else {
            return nil
        }
        return achievementFind
        
        
        
    }
    /**
    Add progress to an achievement
    
    - parameter progress:               Progress achievement Double (ex: 10% = 10.00)
    - parameter achievementIdentifier:  Achievement Identifier
    - parameter showBannnerIfCompleted: if you want show banner when now or not when is completed
    - parameter completionIsSend:       Completion if is send to Game Center
    
    */
    public class func reportAchievement( progress progress : Double, achievementIdentifier : String, showBannnerIfCompleted : Bool = true ,addToExisting: Bool = false) {
        
        guard achievementIdentifier != "" else {
            EGCError.Empty.errorCall()
            return
        }
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return
        }
        guard !EGC.isAchievementCompleted(achievementIdentifier: achievementIdentifier) else {
            EGC.printLogEGC("Achievement is already completed")
            return
        }
        
        guard let achievement = EGC.getAchievementForIndentifier(identifierAchievement: achievementIdentifier) else {
            EGC.printLogEGC("No Achievement for identifier")
            return
        }
        
        
        
        
        let currentValue = achievement.percentComplete
        let newProgress: Double = !addToExisting ? progress : progress + currentValue
        
        achievement.percentComplete = newProgress
        
        /* show banner only if achievement is fully granted (progress is 100%) */
        if achievement.completed && showBannnerIfCompleted {
            EGC.printLogEGC("Achievement \(achievementIdentifier) completed")
            
            if EGC.isConnectedToNetwork {
                achievement.showsCompletionBanner = true
            } else {
                //oneAchievement.showsCompletionBanner = true << Bug For not show two banner
                // Force show Banner when player not have network
                EGC.getTupleGKAchievementAndDescription(achievementIdentifier: achievementIdentifier, completion: {
                    (tupleGKAchievementAndDescription) -> Void in
                    
                    if let tupleIsOK = tupleGKAchievementAndDescription {
                        let title = tupleIsOK.gkAchievementDescription.title
                        let description = tupleIsOK.gkAchievementDescription.achievedDescription
                        
                        EGC.showCustomBanner(title: title!, description: description!)
                    }
                })
            }
        }
        if  achievement.completed && !showBannnerIfCompleted {
            EGC.sharedInstance.achievementsCacheShowAfter[achievementIdentifier] = achievementIdentifier
        }
        EGC.sharedInstance.reportAchievementToGameCenter(achievement: achievement)
        
        
        
        
    }
    /**
    Get GKAchievementDescription
    
    - parameter completion: return array [GKAchievementDescription] or nil
    
    */
    public class func getGKAllAchievementDescription(completion completion: ((arrayGKAD:Set<GKAchievementDescription>?) -> Void)){
        
        
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return
        }
        
        guard EGC.sharedInstance.achievementsDescriptionCache.count > 0 else {
            EGCError.NoAchievement.printError()
            return
        }
        
        var tempsEnvoi = Set<GKAchievementDescription>()
        for achievementDes in EGC.sharedInstance.achievementsDescriptionCache {
            tempsEnvoi.insert(achievementDes.1)
        }
        completion(arrayGKAD: tempsEnvoi)
        
        
    }
    /**
    If achievement is Completed
    
    - parameter Achievement: Identifier
    :return: (Bool) if finished
    
    */
    public class func isAchievementCompleted(achievementIdentifier achievementIdentifier: String) -> Bool{
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return false
        }
        guard let achievement = EGC.getAchievementForIndentifier(identifierAchievement: achievementIdentifier)
            where achievement.completed || achievement.percentComplete == 100.00 else {
            return false
        }
        return true
    }
    /**
    Get Achievements Completes during the game and banner was not showing
    
    - returns: [String : GKAchievement] or nil
    
    */
    public class func getAchievementCompleteAndBannerNotShowing() -> [GKAchievement]? {
        
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return nil
        }

        let achievements : [String:String] = EGC.sharedInstance.achievementsCacheShowAfter
        var achievementsTemps = [GKAchievement]()
        
        if achievements.count > 0 {
            
            for achievement in achievements  {
                if let achievementExtract = EGC.getAchievementForIndentifier(identifierAchievement: achievement.1) {
                    if achievementExtract.completed && achievementExtract.showsCompletionBanner == false {
                        achievementsTemps.append(achievementExtract)
                    }
                }
            }
            return achievementsTemps
        }
        return nil
    }
    /**
    Show all save achievement Complete if you have ( showBannerAchievementWhenComplete = false )
    
    - parameter completion: if is Show Achievement banner
    (Bug Game Center if you show achievement by showsCompletionBanner = true when you report and again you show showsCompletionBanner = false is not show)
    
    */
    public class func showAllBannerAchievementCompleteForBannerNotShowing(completion: ((achievementShow:GKAchievement?) -> Void)? = nil) {
        
            guard EGC.isPlayerIdentified else {
                EGCError.NotLogin.errorCall()
                if completion != nil { completion!(achievementShow: nil) }
                return
            }
        guard let achievementNotShow: [GKAchievement] = EGC.getAchievementCompleteAndBannerNotShowing()  else {

            if completion != nil { completion!(achievementShow: nil) }
            return
        }

        
                    for achievement in achievementNotShow  {
                        
                        EGC.getTupleGKAchievementAndDescription(achievementIdentifier: achievement.identifier!, completion: {
                            (tupleGKAchievementAndDescription) in
                            
                            guard let tupleOK = tupleGKAchievementAndDescription   else {
                                
                                if completion != nil { completion!(achievementShow: nil) }
                                return
                            }
                            
                                //oneAchievement.showsCompletionBanner = true
                                let title = tupleOK.gkAchievementDescription.title
                                let description = tupleOK.gkAchievementDescription.achievedDescription
                                
                                EGC.showCustomBanner(title: title!, description: description!, completion: {
                                    
                                    if completion != nil { completion!(achievementShow: achievement) }
                                })

                        })
                    }
                    EGC.sharedInstance.achievementsCacheShowAfter.removeAll(keepCapacity: false)

        
    }
    /**
    Get progress to an achievement
    
    - parameter Achievement: Identifier
    
    - returns: Double or nil (if not find)
    
    */
    public class func getProgressForAchievement(achievementIdentifier achievementIdentifier:String) -> Double? {

        guard achievementIdentifier != "" else {
            EGCError.Empty.errorCall()
            return nil
        }
        
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return nil
        }
        
        if let achievementInArrayInt = EGC.sharedInstance.achievementsCache[achievementIdentifier]?.percentComplete {
            return achievementInArrayInt
        } else {
            EGCError.Error("No Achievement for achievementIdentifier : \(achievementIdentifier)").errorCall()
            EGCError.NoAchievement.errorCall()
            return nil
        }
        
    }
    /**
    Remove All Achievements
    
    completion: return GKAchievement reset or Nil if game center not work
    sdsds
    */
    public class func resetAllAchievements( completion:  ((achievementReset:GKAchievement?) -> Void)? = nil)  {
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
             if completion != nil { completion!(achievementReset: nil) }
            return
        }
        

                GKAchievement.resetAchievementsWithCompletionHandler({
                    (error:NSError?) in
                    guard error == nil else {
                         EGC.printLogEGC("Couldn't Reset achievement (Send data error)")
                            return
                    }


                        for lookupAchievement in Static.instance!.achievementsCache {
                            let achievementID = lookupAchievement.0
                            let achievementGK = lookupAchievement.1
                            achievementGK.percentComplete = 0
                            achievementGK.showsCompletionBanner = false
                            if completion != nil { completion!(achievementReset:achievementGK) }
                            EGC.printLogEGC("Reset achievement (\(achievementID))")
                        }
                    
                })
    }
    
    /*####################################################################################################*/
    /*                                          Mutliplayer                                               */
    /*####################################################################################################*/
    /**
    Find player By number
    
    - parameter minPlayers: Int
    - parameter maxPlayers: Max
    */
    public class func findMatchWithMinPlayers(minPlayers: Int, maxPlayers: Int) {
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return
        }
        do {
            let delegatVC = try EGC.sharedInstance.getDelegate()

            
            EGC.disconnectMatch()
            
            let request = GKMatchRequest()
            request.minPlayers = minPlayers
            request.maxPlayers = maxPlayers
            
            
            let controlllerGKMatch = GKMatchmakerViewController(matchRequest: request)
            controlllerGKMatch!.matchmakerDelegate = EGC.sharedInstance
            
            var delegeteParent:UIViewController? = delegatVC.parentViewController
            if delegeteParent == nil {
                delegeteParent = delegatVC
            }
            delegeteParent!.presentViewController(controlllerGKMatch!, animated: true, completion: nil)
            
        } catch EGCError.NoDelegate {
            EGCError.NoDelegate.errorCall()
            
        } catch {
            fatalError("Dont work\(error)")
        }
    }
    /**
    Get Player in match
    
    - returns: Set<GKPlayer>
    */
    public class func getPlayerInMatch() -> Set<GKPlayer>? {
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return nil
        }

        guard EGC.sharedInstance.match != nil && EGC.sharedInstance.playersInMatch.count > 0  else {
            EGC.printLogEGC("No Match")
            return nil
        }

        return EGC.sharedInstance.playersInMatch
    }
    /**
    Deconnect the Match
    */
    public class func disconnectMatch() {
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return
        }
        guard let match = EGC.sharedInstance.match else {
            return
        }

        EGC.printLogEGC("Disconnect from match")
        match.disconnect()
        EGC.sharedInstance.match = nil
        (self.delegate as? EGCDelegate)?.EGCMatchEnded?()

    }
    /**
    Get match
    
    - returns: GKMatch or nil if haven't match
    */
    public class func getMatch() -> GKMatch? {
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return nil
        }

        guard let match = EGC.sharedInstance.match else {
            EGC.printLogEGC("No Match")
            return nil
        }
        
        return match
    }
    /**
    player in net
    */
    @available(iOS 8.0, *)
    private func lookupPlayers() {

        guard let match =  EGC.sharedInstance.match else {
            EGC.printLogEGC("No Match")
            return
        }
        
        let playerIDs = match.players.map { $0 .playerID } as! [String]
        
        /* Load an array of player */
        GKPlayer.loadPlayersForIdentifiers(playerIDs) {
            (players, error) in
            
            guard error == nil else {
                EGC.printLogEGC("Error retrieving player info: \(error!.localizedDescription)")
                EGC.disconnectMatch()
                return
            }
            
            guard let players = players else {
                EGC.printLogEGC("Error retrieving players; returned nil")
                return
            }
            if EGC.debugMode {
                for player in players {
                    EGC.printLogEGC("Found player: \(player.alias)")
                }
            }
            
            if let arrayPlayers = players as [GKPlayer]? { self.playersInMatch = Set(arrayPlayers) }
            
            GKMatchmaker.sharedMatchmaker().finishMatchmakingForMatch(match)
            (Static.delegate as? EGCDelegate)?.EGCMatchStarted?()
            
        }
    }
    
    /**
    Transmits data to all players connected to the match.
    
    - parameter data:     NSData
    - parameter modeSend: GKMatchSendDataMode
    
    :GKMatchSendDataMode Reliable: a.s.a.p. but requires fragmentation and reassembly for large messages, may stall if network congestion occurs
    :GKMatchSendDataMode Unreliable: Preferred method. Best effort and immediate, but no guarantees of delivery or order; will not stall.
    */
    public class func sendDataToAllPlayers(data: NSData!, modeSend:GKMatchSendDataMode) {
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return
        }
        guard let match = EGC.sharedInstance.match else {
            EGC.printLogEGC("No Match")
            return
        }
        
        do {
            try match.sendDataToAllPlayers(data, withDataMode: modeSend)
            EGC.printLogEGC("Succes sending data all Player")
        } catch  {
            EGC.disconnectMatch()
            (Static.delegate as? EGCDelegate)?.EGCMatchEnded?()
            EGC.printLogEGC("Fail sending data all Player")
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*####################################################################################################*/
    /*                                    Singleton  Private  Instance                                    */
    /*####################################################################################################*/

    /// ShareInstance Private
    class private var sharedInstance : EGC {
        
        guard let instance = Static.instance else {
            EGCError.Error("No Instance, please sharedInstance of EasyGameCenter").errorCall()
            fatalError("No Instance, please sharedInstance of EasyGameCenter")
        }
        return instance
    }
    /**
    Delegate UIViewController
    
    
    - throws: .NoDelegate
    
    - returns: UIViewController
    */
    private func getDelegate() throws -> UIViewController {
        guard let delegate = Static.delegate else {
            throw EGCError.NoDelegate
        }
        return delegate
    }
    
    /*####################################################################################################*/
    /*                                            private Start                                           */
    /*####################################################################################################*/
    /**
    Init Implemented by subclasses to initialize a new object
    
    - returns: An initialized object
    */
    //override init() { super.init() }
    
    /**
    Completion for cachin Achievements and AchievementsDescription
    
    - parameter achievementsType: GKAchievement || GKAchievementDescription
    */
    private static func completionCachingAchievements(achievementsType :[AnyObject]?) {
        
        func finish() {
            if EGC.sharedInstance.achievementsCache.count > 0 &&
               EGC.sharedInstance.achievementsDescriptionCache.count > 0 {

                    (Static.delegate as? EGCDelegate)?.EGCInCache?()
                    
            }
        }
        
        
        // Type GKAchievement
        if achievementsType is [GKAchievement] {
            
            guard let arrayGKAchievement = achievementsType as? [GKAchievement] where arrayGKAchievement.count > 0 else {
                EGCError.CantCachingGKAchievement.errorCall()
                return
            }
            
            for anAchievement in arrayGKAchievement where  anAchievement.identifier != nil {
                EGC.sharedInstance.achievementsCache[anAchievement.identifier!] = anAchievement
            }
            finish()
            
            // Type GKAchievementDescription
        } else if achievementsType is [GKAchievementDescription] {
            
            guard let arrayGKAchievementDes = achievementsType as? [GKAchievementDescription] where arrayGKAchievementDes.count > 0 else {
                EGCError.CantCachingGKAchievementDescription.errorCall()
                return
            }
            
            for anAchievementDes in arrayGKAchievementDes where  anAchievementDes.identifier != nil {
                
                // Add GKAchievement
                if EGC.sharedInstance.achievementsCache.indexForKey(anAchievementDes.identifier!) == nil {
                    EGC.sharedInstance.achievementsCache[anAchievementDes.identifier!] = GKAchievement(identifier: anAchievementDes.identifier!)
                    
                }
                // Add CGAchievementDescription
                EGC.sharedInstance.achievementsDescriptionCache[anAchievementDes.identifier!] = anAchievementDes
            }
            
            GKAchievement.loadAchievementsWithCompletionHandler({
                (allAchievements, error) in
                
                guard (error == nil) && allAchievements!.count != 0  else {
                    finish()
                    return
                }
                
                EGC.completionCachingAchievements(allAchievements)
                
            })
        }
    }
    
    
    
    /**
    Load achievements in cache
    (Is call when you init EGC, but if is fail example for cut connection, you can recall)
    And when you get Achievement or all Achievement, it shall automatically cached
    
    */
    private func cachingAchievements() {
        guard EGC.isConnectedToNetwork else {
            EGCError.NoConnection.errorCall()
            return
        }
        guard EGC.isPlayerIdentified else {
            EGCError.NotLogin.errorCall()
            return
        }
        // Load GKAchievementDescription
        GKAchievementDescription.loadAchievementDescriptionsWithCompletionHandler({
            (achievementsDescription, error) in
            guard error == nil else {
                EGCError.Error(error?.localizedDescription).errorCall()
                return
            }
            EGC.completionCachingAchievements(achievementsDescription)
        })
    }
    /**
    Login player to GameCenter With Handler Authentification
    This function is recall When player connect to Game Center
    
    - parameter completion: (Bool) if player login to Game Center
    */
    /// Authenticates the user with their Game Center account if possible
    
    // MARK: Internal functions
    
    internal func authenticationChanged() {
        guard let delegateEGC = Static.delegate as? EGCDelegate else {
            return
        }
        if EGC.isPlayerIdentified {
            delegateEGC.EGCAuthentified?(true)
            EGC.sharedInstance.cachingAchievements()
        } else {
            delegateEGC.EGCAuthentified?(false)
        }
    }
    
    private func loginPlayerToGameCenter()  {
        
        guard !EGC.isPlayerIdentified else {
            return
        }
        
        guard let delegateVC = Static.delegate  else {
            EGCError.NoDelegate.errorCall()
            return
        }
        
        guard EGC.isConnectedToNetwork else {
            EGCError.NoConnection.errorCall()
            return
        }
        
        GKLocalPlayer.localPlayer().authenticateHandler = {
            (gameCenterVC, error) in
            
            guard error == nil else {
                EGCError.Error("User has canceled authentication").errorCall()
                return
            }
            guard let gcVC = gameCenterVC else {
                return
            }
            if EGC.showLoginPage {
                dispatch_async(dispatch_get_main_queue()) {
                    delegateVC.presentViewController(gcVC, animated: true, completion: nil)
                }
            }

            
        }
    }

    /*####################################################################################################*/
    /*                              Private Timer checkup                                                 */
    /*####################################################################################################*/
    /**
    Function checkup when he have net work login Game Center
    */
    func checkupNetAndPlayer() {
        dispatch_async(dispatch_get_main_queue()) {
            if self.timerNetAndPlayer == nil {
                self.timerNetAndPlayer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("checkupNetAndPlayer"), userInfo: nil, repeats: true)
            }
            
            if EGC.isConnectedToNetwork {
                self.timerNetAndPlayer!.invalidate()
                self.timerNetAndPlayer = nil
                
                EGC.sharedInstance.loginPlayerToGameCenter()
            }
        }
    }
    
    /*####################################################################################################*/
    /*                                      Private Func Achievements                                     */
    /*####################################################################################################*/
    /**
    Report achievement classic
    
    - parameter achievement: GKAchievement
    */
    private func reportAchievementToGameCenter(achievement achievement:GKAchievement) {
        /* try to report the progress to the Game Center */
        
        GKAchievement.reportAchievements([achievement], withCompletionHandler:  {
            (error:NSError?) -> Void in
            if error != nil { /* Game Center Save Automatique */ }
        })
    }
    /*####################################################################################################*/
    /*                             Public Delagate Game Center                                          */
    /*####################################################################################################*/
    /**
    Dismiss Game Center when player open
    - parameter GKGameCenterViewController:
    
    Override of GKGameCenterControllerDelegate
    
    */
    public func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*####################################################################################################*/
    /*                                          GKMatchDelegate                                           */
    /*####################################################################################################*/
    /**
    Called when data is received from a player.
    
    - parameter theMatch: GKMatch
    - parameter data:     NSData
    - parameter playerID: String
    */
    public func match(theMatch: GKMatch, didReceiveData data: NSData, fromPlayer playerID: String) {
        guard EGC.sharedInstance.match == theMatch else {
            return
        }
        (Static.delegate as? EGCDelegate)?.EGCMatchRecept?(theMatch, didReceiveData: data, fromPlayer: playerID)

    }
    /**
    Called when a player connects to or disconnects from the match.
    
    Echange avec autre players
    
    - parameter theMatch: GKMatch
    - parameter playerID: String
    - parameter state:    GKPlayerConnectionState
    */
   
    public func match(theMatch: GKMatch, player playerID: String, didChangeState state: GKPlayerConnectionState) {
        /* recall when is desconnect match = nil */
        guard self.match == theMatch else {
            return
        }
        
        switch state {
        /* Connected */
        case .StateConnected where self.match != nil && theMatch.expectedPlayerCount == 0:
            if #available(iOS 8.0, *) {
                self.lookupPlayers()
            }
        /* Lost deconnection */
        case .StateDisconnected:
            EGC.disconnectMatch()
        default:
            break
        }
    }
    /**
    Called when the match cannot connect to any other players.
    
    - parameter theMatch: GKMatch
    - parameter error:    NSError
    
    */
    public func match(theMatch: GKMatch, didFailWithError error: NSError?) {
        guard self.match == theMatch else {
            return
        }
        
        guard error == nil else {
            EGCError.Error("Match failed with error: \(error?.localizedDescription)").errorCall()
            EGC.disconnectMatch()
            return
        }
    }
    
    /*####################################################################################################*/
    /*                            GKMatchmakerViewControllerDelegate                                      */
    /*####################################################################################################*/
    /**
    Called when a peer-to-peer match is found.
    
    - parameter viewController: GKMatchmakerViewController
    - parameter theMatch:       GKMatch
    */
    public func matchmakerViewController(viewController: GKMatchmakerViewController, didFindMatch theMatch: GKMatch) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
        self.match = theMatch
        self.match!.delegate = self
        if match!.expectedPlayerCount == 0 {
            if #available(iOS 8.0, *) {
                self.lookupPlayers()
            }
        }
    }
    
    
    /*####################################################################################################*/
    /*                             GKLocalPlayerListener                                                  */
    /*####################################################################################################*/
    /**
    Called when another player accepts a match invite from the local player
    
    - parameter player:         GKPlayer
    - parameter inviteToAccept: GKPlayer
    */
    public func player(player: GKPlayer, didAcceptInvite inviteToAccept: GKInvite) {
        guard let gkmv = GKMatchmakerViewController(invite: inviteToAccept) else {
            EGCError.Error("GKMatchmakerViewController invite to accept nil").errorCall()
            return
        }
        gkmv.matchmakerDelegate = self
        
        var delegeteParent:UIViewController? = EGC.delegate.parentViewController
        if delegeteParent == nil {
            delegeteParent = EGC.delegate
        }
        delegeteParent!.presentViewController(gkmv, animated: true, completion: nil)
    }
    /**
    Initiates a match from Game Center with the requested players
    
    - parameter player:          The GKPlayer object containing the current player’s information
    - parameter playersToInvite: An array of GKPlayer
    */
    public func player(player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) { }
    
    /**
    Called when the local player starts a match with another player from Game Center
    
    - parameter player:            The GKPlayer object containing the current player’s information
    - parameter playerIDsToInvite: An array of GKPlayer
    */
    public func player(player: GKPlayer, didRequestMatchWithPlayers playerIDsToInvite: [String]) { }
    
    /*####################################################################################################*/
    /*                            GKMatchmakerViewController                                              */
    /*####################################################################################################*/
    /**
    Called when the user cancels the matchmaking request (required)
    
    - parameter viewController: GKMatchmakerViewController
    */
    public func matchmakerViewControllerWasCancelled(viewController: GKMatchmakerViewController) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)

        (Static.delegate as? EGCDelegate)?.EGCMatchCancel?()
        EGC.printLogEGC("Player cancels the matchmaking request")

    }
    /**
    Called when the view controller encounters an unrecoverable error.
    
    - parameter viewController: GKMatchmakerViewController
    - parameter error:          NSError
    */
    public func matchmakerViewController(viewController: GKMatchmakerViewController, didFailWithError error: NSError) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        (Static.delegate as? EGCDelegate)?.EGCMatchCancel?()
        EGCError.Error("Error finding match: \(error.localizedDescription)\n").errorCall()

    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

/*####################################################################################################*/
/*                                          Debug                                                     */
/*####################################################################################################*/

// MARK: - Extension EGC Debug
extension EGC {
    /**
    Print 
    
    - parameter object: Any
    */
    private class func printLogEGC(object: Any) {
        if EGC.debugMode {
            dispatch_async(dispatch_get_main_queue()) {
                 Swift.print("\n[Easy Game Center] \(object)\n")
            }
        }
    }
}
// MARK: - Debug  /  Error Func
extension EGC {
    /**
    ErrorType debug
    
    - Error:                               Some Error
    - CantCachingGKAchievementDescription: Cant caching GKAchievements Des
    - CantCachingGKAchievement:            Cant caching GKAchievements
    - NoAchievement:                       No Achievement create
    - Empty:                               Param empty
    - NoConnection:                        No internet
    - NotLogin:                            No login
    - NoDelegate:                          No Delegate
    */
    private enum EGCError : ErrorType {
        case Error(String?)
        case CantCachingGKAchievementDescription
        case CantCachingGKAchievement
        case NoAchievement
        case Empty
        case NoConnection
        case NotLogin
        case NoDelegate
        
        /// Description
        var description : String {
            
            switch self {
                
            case .Error(let error):
                return (error != nil) ? "\(error!)" : "\(error)"
                
            case .CantCachingGKAchievementDescription:
                return "Can't caching GKAchievementDescription\n( Have you create achievements in ItuneConnect ? )"
                
            case .CantCachingGKAchievement:
                return "Can' t caching GKAchievement\n( Have you create achievements in ItuneConnect ? )"
                
            case .NoAchievement:
                return "No GKAchievement and GKAchievementDescription\n\n( Have you create achievements in ItuneConnect ? )"
                
            case .NoConnection:
                return "No internet connection"
                
            case .NotLogin:
                return "User is not identified to game center"
                
            case .NoDelegate :
                return "\nDelegate UIViewController not added"
                
            case .Empty:
                return "\nThe parameter is empty"
            }
        }
        /**
        Print Debug Enum error
        
        - parameter error: EGCError
        */
        private func printError(error: EGCError) {
            EGC.printLogEGC(error.description)
        }
        /**
        Print self enum error
        */
        private func printError() {
            EGC.printLogEGC(self.description)
        }
        /**
        Handler error
        */
        private func errorCall() {
            
            defer { self.printError() }
            
            switch self {
            case .NotLogin:
                (EGC.delegate  as? EGCDelegate)?.EGCAuthentified?(false)
                break
            case .CantCachingGKAchievementDescription:
                EGC.sharedInstance.checkupNetAndPlayer()
                break
            case .CantCachingGKAchievement:
                
                break
            default:
                break
            }
        }
    }
    
    
    
}