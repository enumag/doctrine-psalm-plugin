Feature: ObjectManager
  In order to use Doctrine ObjectManager safely
  As a Psalm user
  I need Psalm to typecheck ObjectManager

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm totallyTyped="true">
        <projectFiles>
          <directory name="."/>
        </projectFiles>
        <plugins>
          <pluginClass class="Weirdan\DoctrinePsalmPlugin\Plugin" />
        </plugins>
      </psalm>
      """
    And I have the following code preamble
      """
      <?php
      use Doctrine\Persistence\ObjectManager;

      interface I {}

      /**
       * @return ObjectManager
       * @psalm-suppress InvalidReturnType
       */
      function om() {}

      """

  @ObjectManager::getRepository
  Scenario: Calling getRepository with a class-string argument
    Given I have the following code
      """
      atan(om()->getRepository(I::class));
      """
    When I run Psalm
    Then I see these errors
      | Type            | Message                                                                             |
      | InvalidArgument | Argument 1 of atan expects float, Doctrine\Persistence\ObjectRepository<I> provided |

  @ObjectManager::getRepository
  Scenario: Calling getRepository with a wrong argument type
    Given I have the following code
      """
      om()->getRepository(123);
      """
    When I run Psalm
    Then I see these errors
      | Type                  | Message                                                                                                 |
      | InvalidScalarArgument | Argument 1 of Doctrine\Persistence\ObjectManager::getRepository expects class-string, int(123) provided |

  @ObjectManager::getClassMetadata
  Scenario: Calling getClassMetadata with a class-string argument
    Given I have the following code
      """
      atan(om()->getClassMetadata(I::class));
      """
    When I run Psalm
    Then I see these errors
      | Type            | Message                                                                                  |
      | InvalidArgument | Argument 1 of atan expects float, Doctrine\Persistence\Mapping\ClassMetadata<I> provided |

  @ObjectManager::getClassMetadata
  Scenario: Calling getClassMetadata with a wrong argument type
    Given I have the following code
      """
      om()->getClassMetadata(123);
      """
    When I run Psalm
    Then I see these errors
      | Type                  | Message                                                                                                    |
      | InvalidScalarArgument | Argument 1 of Doctrine\Persistence\ObjectManager::getClassMetadata expects class-string, int(123) provided |

  @ObjectManager::find
  Scenario: Calling find with a class-string argument
    Given I have the following code
      """
      atan(om()->find(I::class, 1));
      """
    When I run Psalm
    Then I see these errors
      | Type            | Message                                            |
      | InvalidArgument | Argument 1 of atan expects float, I\|null provided |

  @ObjectManager::find
  Scenario: Calling find with a wrong argument type
    Given I have the following code
      """
      om()->find(123, 1);
      """
    When I run Psalm
    Then I see these errors
      | Type                  | Message                                                                                        |
      | InvalidScalarArgument | Argument 1 of Doctrine\Persistence\ObjectManager::find expects class-string, int(123) provided |
